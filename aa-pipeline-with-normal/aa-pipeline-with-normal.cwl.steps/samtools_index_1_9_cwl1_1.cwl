cwlVersion: v1.0
class: CommandLineTool
label: Samtools Index CWL1.0
doc: |-
  **SAMtools Index** tool is used to index a coordinate-sorted BAM or CRAM file for fast random access. Note that this does not work with SAM files even if they are bgzip compressed — to index such files, use tabix instead. This index is needed when region arguments are used to limit **SAMtools View** and similar commands to particular regions of interest. For a CRAM file aln.cram, index file aln.cram.crai will be created; for a BAM file aln.bam, either aln.bam.bai or aln.bam.csi will be created, depending on the index format selected [1].

  *A list of **all inputs and parameters** with corresponding descriptions can be found at the bottom of the page.*

  ###Common Use Cases 

  - When using this tool as a standalone tool, **Input index file** should not be provided. This input is given as an option that is convenient to use in workflows. 
  - When using this tool in a workflow, **Input index file** can be provided. In case it is provided, tool execution will be skipped and it will just pass the inputs through. This is useful for workflows which use tools that require an index file when it is not known in advance if the input BAM/CRAM file will have accompanying index file present in the project. If the next tool in the workflow requires an index file as a secondary file, parameter **Output indexed data file** should be set to True. This will provide a BAM/CRAM file at the **Indexed data file** output port along with its index file (BAI/CSI/CRAI) as the secondary file.
  - If a CRAM file is provided at the **BAM/CRAM input file** port, the tool will generate a CRAI index file. If a BAM file is provided, the tool will generate a BAI or CSI index file depending on the parameter **Format of index file (for BAM files)** (`-b/-c`). If no value is set, the tool will generate a BAI index file. Setting the parameter **Minimum interval size (2^INT)** (`-m`) will force the CSI format regardless of the value of the parameter **Format of index file (for BAM files)**.

  ###Changes Introduced by Seven Bridges

  - Parameter **Output filename** is omitted from the wrapper. For a CRAM file aln.cram, output filename will be aln.cram.crai; for a BAM file aln.bam, it will be either aln.bam.bai or aln.bam.csi, depending on the index format selected.
  - Parameter **Output indexed data file** and file input **Input index file** are added to provide additional options for integration with other tools within a workflow. 

  ###Common Issues and Important Notes

  - **BAM/CRAM input file** should be sorted by coordinates, not by name. Otherwise, the task will fail.
  - **When using this tool in a workflow, if the next tool in the workflow requires index file as a secondary file, parameter Output indexed data file should be set to True. This will provide BAM/CRAM file at Indexed data file output port along with its index file (BAI/CSI/CRAI) as secondary file.**

  ###Performance Benchmarking

  Multithreading can be enabled by setting parameter **Number of threads** (`-@`). In the following table you can find estimates of **SAMtools Index** running time and cost.

  *Cost can be significantly reduced by using **spot instances**. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*  

  | Input type | Input size | # of reads | Read length |  # of threads | Duration | Cost | Instance (AWS)|
  |---------------|--------------|---------------|------------------|---------------------|-------------|--------|-------------|
  |  BAM | 5.26 GB | 71.5M | 76 | 1 | 4min. | \$0.04 | c4.2xlarge |
  |  BAM | 11.86 GB | 161.2M | 101| 1 | 10min. | \$0.09 | c4.2xlarge |
  |  BAM | 18.36 GB | 179M | 76 | 1 | 12min. | \$0.11 | c4.2xlarge |
  |  BAM | 58.61 GB | 845.6M | 150 | 1 | 36min. | \$0.32 | c4.2xlarge |
  |  BAM | 5.26 GB | 71.5M | 76 | 8 | 3min. | \$0.03 | c4.2xlarge |
  |  BAM | 11.86 GB | 161.2M | 101| 8 | 9min. | \$0.08 | c4.2xlarge |
  |  BAM | 18.36 GB | 179M | 76 | 8 | 11min. | \$0.10 | c4.2xlarge |
  |  BAM | 58.61 GB | 845.6M | 150 | 8 | 30min. | \$0.27 | c4.2xlarge |

  ###References

  [1] [SAMtools documentation](http://www.htslib.org/doc/samtools-1.9.html)
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: |-
    ${
        if (inputs.cpu_per_job) {
            return inputs.cpu_per_job
        }
        else {
        var threads = 1
        if (inputs.threads) {
            threads = inputs.threads
        }

        if (inputs.in_index) {
            var index_ext = [].concat(inputs.in_index)[0].path.substr([].concat(inputs.in_index)[0].path.lastIndexOf('.') + 1)
            var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)
            var index_format = 'BAI'
            if (inputs.index_file_format) {
                index_format = inputs.index_file_format
            }
            if (inputs.minimum_interval_size) {
                index_format = ''
            }

            if ((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||
                (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')) {
                return 1
            } else {
                return threads
            }
        } else {
            return threads
        }
        }
    }
  ramMin: |-
    ${
        if (inputs.mem_per_job) {
            return inputs.mem_per_job
        }
        else {
            return 1500
        }
    }
- class: DockerRequirement
  dockerPull: images.sbgenomics.com/jrandjelovic/samtools-1-9:1
  dockerImageId: 2fb927277493
- class: InitialWorkDirRequirement
  listing:
  - $(inputs.in_alignments)
  - $(inputs.in_index)
  - $(inputs.in_reference)
- class: InlineJavascriptRequirement
  expressionLib:
  - |
    var setMetadata = function(file, metadata) {
        if (!('metadata' in file)) {
            file['metadata'] = {}
        }
        for (var key in metadata) {
            file['metadata'][key] = metadata[key];
        }
        return file
    };

    var inheritMetadata = function(o1, o2) {
        var commonMetadata = {};
        if (!o2) {
            return o1;
        };
        if (!Array.isArray(o2)) {
            o2 = [o2]
        }
        for (var i = 0; i < o2.length; i++) {
            var example = o2[i]['metadata'];
            for (var key in example) {
                if (i == 0)
                    commonMetadata[key] = example[key];
                else {
                    if (!(commonMetadata[key] == example[key])) {
                        delete commonMetadata[key]
                    }
                }
            }
            for (var key in commonMetadata) {
                if (!(key in example)) {
                    delete commonMetadata[key]
                }
            }
        }
        if (!Array.isArray(o1)) {
            o1 = setMetadata(o1, commonMetadata)
        } else {
            for (var i = 0; i < o1.length; i++) {
                o1[i] = setMetadata(o1[i], commonMetadata)
            }
        }
        return o1;
    };

inputs:
- id: in_alignments
  label: BAM/CRAM input file
  doc: BAM/CRAM input file.
  type: File
  inputBinding:
    position: 100
    valueFrom: |-
      ${
          if (inputs.in_index) {
              var index_ext = [].concat(inputs.in_index)[0].path.substr([].concat(inputs.in_index)[0].path.lastIndexOf('.') + 1)
              var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)
              var index_format = 'BAI'
              if (inputs.index_file_format) {
                  index_format = inputs.index_file_format
              }
              if (inputs.minimum_interval_size) {
                  index_format = ''
              }

              if ((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||
                  (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')) {
                  return
              } else {
                  return inputs.in_alignments.path
              }
          } else {
              return inputs.in_alignments.path
          }
      }
    shellQuote: false
  sbg:category: File Inputs
  sbg:fileTypes: BAM, CRAM
- id: output_indexed_data
  label: Output indexed data file
  doc: |-
    Setting this parameter to True will provide BAM file (and BAI file as secondary file) at Indexed data file output port. The default value is False.
  type: boolean?
  sbg:category: Config Inputs
  sbg:toolDefaultValue: 'False'
- id: in_index
  label: Input index file
  doc: |-
    Input index file (CSI, CRAI, or BAI). If an input BAM/CRAM file is already indexed, index file can be provided at this port. If it is provided, the tool will just pass it through. This option is useful for workflows when it is not know in advance if the input BAM/CRAM file has accompanying index file present in the project.
  type: File?
  sbg:category: File Inputs
  sbg:fileTypes: BAI, CSI, CRAI
- id: minimum_interval_size
  label: Minimum interval size (2^INT)
  doc: |-
    Set minimum interval size for CSI indices to 2^INT. Default value is 14. Setting this value will force generating CSI index file (if the input file is BAM) regardless of the value of the parameter Format of index file (for BAM files).
  type: int?
  default: 0
  inputBinding:
    prefix: -m
    position: 2
    valueFrom: |-
      ${
          var self
          if (self == 0) {
              self = null;
              inputs.minimum_interval_size = null
          };


          if (inputs.minimum_interval_size) {
              if (inputs.in_index) {
                  var index_ext = [].concat(inputs.in_index)[0].path.substr([].concat(inputs.in_index)[0].path.lastIndexOf('.') + 1)
                  var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)
                  var index_format = 'BAI'
                  if (inputs.index_file_format) {
                      index_format = inputs.index_file_format
                  }
                  if (inputs.minimum_interval_size) {
                      index_format = ''
                  }

                  if ((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||
                      (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')) {
                      return
                  } else {
                      return inputs.minimum_interval_size
                  }
              } else {
                  return inputs.minimum_interval_size
              }
          } else {
              return
          }
      }
    shellQuote: false
  sbg:category: Config Inputs
  sbg:toolDefaultValue: '14'
- id: index_file_format
  label: Format of index file (for BAM files)
  doc: |-
    Choose which file format will be generated for index file (BAI or CSI) if the input is BAM file. In case the input is CRAM file, this will be ignored and the tool will generate CRAI file.
  type:
  - 'null'
  - name: index_file_format
    type: enum
    symbols:
    - BAI
    - CSI
  default: 0
  inputBinding:
    position: 1
    valueFrom: |-
      ${
          var self
          if (self == 0) {
              self = null;
              inputs.index_file_format = null
          };


          if (inputs.index_file_format) {
              if (inputs.in_index) {
                  var index_ext = [].concat(inputs.in_index)[0].path.substr([].concat(inputs.in_index)[0].path.lastIndexOf('.') + 1)
                  var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)
                  var index_format = inputs.index_file_format
                  if (inputs.minimum_interval_size) {
                      index_format = ''
                  }

                  if ((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||
                      (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')) {
                      return
                  } else {
                      if (inputs.index_file_format === 'BAI') {
                          return '-b'
                      } else if (inputs.index_file_format === 'CSI') {
                          return '-c'
                      }
                  }
              } else {
                  if (inputs.index_file_format === 'BAI') {
                      return '-b'
                  } else if (inputs.index_file_format === 'CSI') {
                      return '-c'
                  }
              }
          } else {
              return
          }
      }
    shellQuote: false
  sbg:category: Config Inputs
  sbg:toolDefaultValue: BAI
- id: threads
  label: Number of threads
  doc: Number of threads.
  type: int?
  default: 0
  inputBinding:
    prefix: -@
    position: 1
    valueFrom: |-
      ${
          var self
          if (self == 0) {
              self = null;
              inputs.threads = null
          };


          if (inputs.threads) {
              if (inputs.in_index) {
                  var index_ext = [].concat(inputs.in_index)[0].path.substr([].concat(inputs.in_index)[0].path.lastIndexOf('.') + 1)
                  var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)
                  var index_format = 'BAI'
                  if (inputs.index_file_format) {
                      index_format = inputs.index_file_format
                  }
                  if (inputs.minimum_interval_size) {
                      index_format = ''
                  }

                  if ((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||
                      (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')) {
                      return
                  } else {
                      return inputs.threads
                  }
              } else {
                  return inputs.threads
              }
          } else {
              return
          }
      }
    shellQuote: false
  sbg:category: Execution
  sbg:toolDefaultValue: '1'
- id: in_reference
  label: Reference file
  doc: |-
    A FASTA format reference file, optionally compressed by bgzip and ideally indexed by SAMtools Faidx. If an index is not present, one will be generated for you. This file is used for compression/decompression of CRAM files. Please provide reference file when using CRAM input/output file.
  type: File?
  sbg:altPrefix: --reference
  sbg:category: File Inputs
  sbg:fileTypes: FASTA, FA, FASTA.GZ, FA.GZ, GZ
- id: mem_per_job
  label: Memory per job
  doc: Memory per job in MB.
  type: int?
  sbg:category: Platform Options
  sbg:toolDefaultValue: '1500'
- id: cpu_per_job
  label: CPU per job
  doc: Number of CPUs per job.
  type: int?
  sbg:category: Platform Options
  sbg:toolDefaultValue: '1'

outputs:
- id: indexed_data_file
  label: Indexed data file
  doc: Output BAM/CRAM, along with its index as secondary file.
  type: File?
  secondaryFiles:
  - .bai
  - .crai
  - ^.bai
  - ^.crai
  - .csi
  - ^.csi
  outputBinding:
    glob: |-
      ${
          if (inputs.output_indexed_data === true) {
              return [].concat(inputs.in_alignments)[0].path.split("/").pop()
          } else {
              return ''
          }
      }
    outputEval: |-
      ${
          for (var i = 0; i < self.length; i++){
              self[i] = inheritMetadata(self[i], inputs.in_alignments);
              if (self.hasOwnProperty('secondaryFiles')){
                  for (var j = 0; j < self[i].secondaryFiles.length; j++){
                      self[i].secondaryFiles[j] = inheritMetadata(self[i].secondaryFiles[j], inputs.in_alignments);
                  }
              }
          }
          return self;
      }
  sbg:fileTypes: BAM, CRAM
- id: out_index
  label: Generated index file
  doc: Generated index file (without the indexed data).
  type: File?
  outputBinding:
    glob: |-
      ${
          var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)
          if (input_ext.toUpperCase() === 'CRAM') {
              return '*.crai'
          } else if (input_ext.toUpperCase() === 'BAM') {
              var index_format = 'BAI'
              if (inputs.index_file_format) {
                  index_format = inputs.index_file_format
              }
              if (inputs.minimum_interval_size) {
                  index_format = 'CSI'
              }
              return '*.' + index_format.toLowerCase()
          }
      }
    outputEval: |-
      ${
          if (inputs.in_index) {
              for (var i = 0; i < self.length; i++){
                      self[i] = inheritMetadata(self[i], inputs.in_index);
          }
          return self
          }
          else {
          for (var i = 0; i < self.length; i++){
                      self[i] = inheritMetadata(self[i], inputs.in_alignments);
          }
          return self;
          }
      }
  sbg:fileTypes: BAI, CRAI, CSI
stdout: path.log

baseCommand: []
arguments:
- prefix: ''
  position: 0
  valueFrom: |-
    ${
        if (inputs.in_index) {
            var index_ext = [].concat(inputs.in_index)[0].path.substr([].concat(inputs.in_index)[0].path.lastIndexOf('.') + 1)
            var input_ext = [].concat(inputs.in_alignments)[0].path.substr([].concat(inputs.in_alignments)[0].path.lastIndexOf('.') + 1)
            var index_format = 'BAI'
            if (inputs.index_file_format) {
                index_format = inputs.index_file_format
            }
            if (inputs.minimum_interval_size) {
                index_format = ''
            }

            if ((index_ext.toUpperCase() === 'CRAI' && input_ext.toUpperCase() === 'CRAM') ||
                (index_ext.toUpperCase() === index_format && input_ext.toUpperCase() === 'BAM')) {
                return "echo Skipping index step because an index file is provided on the input."
            } else {
                return "/opt/samtools-1.9/samtools index"
            }
        } else {
            return "/opt/samtools-1.9/samtools index"
        }
    }
  shellQuote: false
- position: 1001
  valueFrom: '&& echo $REF_PATH'
  shellQuote: false

hints:
- class: sbg:saveLogs
  value: path.log
- class: sbg:saveLogs
  value: job.tree.log
id: chapmano/pancancer-ecdna/samtools-index-1-9-cwl1-0/0
sbg:appVersion:
- v1.0
sbg:categories:
- Utilities
- BAM Processing
- CWL1.0
sbg:cmdPreview: /opt/samtools-1.9/samtools index /path/to/file.bam
sbg:content_hash: a24d970ada7186ed353878e9c7ef2d2d22b210747468bef952668b223a1212fa2
sbg:contributors:
- adutta
sbg:copyOf: chapmano/medulloblastoma-ecdna/samtools-index-1-9-cwl1-0/0
sbg:createdBy: adutta
sbg:createdOn: 1633026174
sbg:id: chapmano/pancancer-ecdna/samtools-index-1-9-cwl1-0/0
sbg:image_url:
sbg:latestRevision: 0
sbg:license: MIT License
sbg:links:
- id: http://www.htslib.org/
  label: Homepage
- id: https://github.com/samtools/samtools
  label: Source Code
- id: https://github.com/samtools/samtools/wiki
  label: Wiki
- id: https://sourceforge.net/projects/samtools/files/
  label: Download
- id: http://www.ncbi.nlm.nih.gov/pubmed/19505943
  label: Publication
- id: http://www.htslib.org/doc/samtools-1.9.html
  label: Documentation
sbg:modifiedBy: adutta
sbg:modifiedOn: 1633026174
sbg:project: chapmano/pancancer-ecdna
sbg:projectName: pancancer-ecDNA
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes: Copy of chapmano/medulloblastoma-ecdna/samtools-index-1-9-cwl1-0/0
sbg:revisionsInfo:
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1633026174
  sbg:revision: 0
  sbg:revisionNotes: Copy of chapmano/medulloblastoma-ecdna/samtools-index-1-9-cwl1-0/0
sbg:sbgMaintained: false
sbg:toolAuthor: |-
  Heng Li (Sanger Institute), Bob Handsaker (Broad Institute), Jue Ruan (Beijing Genome Institute), Colin Hercus, Petr Danecek
sbg:toolkit: SAMtools
sbg:toolkitVersion: '1.9'
sbg:validationErrors: []
