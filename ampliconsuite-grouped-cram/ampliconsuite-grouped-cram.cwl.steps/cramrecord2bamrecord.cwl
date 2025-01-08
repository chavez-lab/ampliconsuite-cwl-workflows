cwlVersion: v1.2
class: Workflow
label: cramrecord2bamrecord
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: input_record
  type:
    name: input_record
    type: record
    fields:
    - name: sample_name
      type: string
    - name: cram
      type: File
      secondaryFiles:
      - pattern: .crai
        required: true
    - name: tumor_normal
      doc: May only be "tumor" or "normal"
      type: string
  sbg:x: -728
  sbg:y: -78.49347686767578
- id: reference_file_list
  label: List of reference names and lengths
  doc: |-
    A tab-delimited file. Each line must contain the reference name in the first column and the length of the reference in the second column, with one line for each distinct reference. Any additional fields beyond the second column are ignored. This file also defines the order of the reference sequences in sorting. If you run SAMtools Faidx on reference FASTA file (<ref.fa>), the resulting index file <ref.fa>.fai can be used as this file.
  type: File?
  sbg:fileTypes: FAI, TSV, TXT
  sbg:x: -392.5195617675781
  sbg:y: -432.5533447265625
- id: in_reference
  label: Reference file
  doc: |-
    A FASTA format reference file, optionally compressed by bgzip and ideally indexed by SAMtools Faidx. If an index is not present, one will be generated for you. This file is used for compression/decompression of CRAM files. Please provide reference file when using CRAM input/output file.
  type: File?
  sbg:fileTypes: FASTA, FA, FASTA.GZ, FA.GZ, GZ
  sbg:x: -561.0107421875
  sbg:y: -281.5824890136719

outputs:
- id: output
  type:
  - 'null'
  - name: output
    type: record
    fields:
    - name: sample_name
      type: string?
      outputBinding:
        outputEval: $(inputs.sample_name)
    - name: bam
      type: File
      outputBinding:
        outputEval: $(inputs.bam)
    - name: tumor_normal
      type: string
      outputBinding:
        outputEval: $(inputs.tumor_normal)
  outputSource:
  - record_constructor/output
  sbg:x: 641.06494140625
  sbg:y: -83.7402572631836

steps:
- id: record_deconstructor
  label: record-deconstructor
  in:
  - id: input_record
    source: input_record
  run: cramrecord2bamrecord.cwl.steps/record_deconstructor.cwl
  out:
  - id: sample_name
  - id: cram
  - id: tumor_normal
  sbg:x: -528.5665893554688
  sbg:y: -81.73538208007812
- id: record_constructor
  label: record-constructor
  in:
  - id: sample_name
    source: record_deconstructor/sample_name
  - id: bam
    source: samtools_index_1_9_cwl1_0/indexed_data_file
  - id: tumor_normal
    source: record_deconstructor/tumor_normal
  run: cramrecord2bamrecord.cwl.steps/record_constructor.cwl
  out:
  - id: output
  sbg:x: 373.55963134765625
  sbg:y: -82.17430877685547
- id: samtools_view_1_9_cwl1_0
  label: Samtools View CWL1.0
  in:
  - id: output_format
    default: BAM
  - id: include_header
    default: true
  - id: in_reference
    source: in_reference
  - id: reference_file_list
    source: reference_file_list
  - id: in_alignments
    source: record_deconstructor/cram
  run: cramrecord2bamrecord.cwl.steps/samtools_view_1_9_cwl1_0.cwl
  out:
  - id: out_alignments
  - id: reads_not_selected_by_filters
  - id: alignement_count
  sbg:x: -212
  sbg:y: 13
- id: samtools_index_1_9_cwl1_0
  label: Samtools Index CWL1.0
  in:
  - id: in_alignments
    source: samtools_view_1_9_cwl1_0/out_alignments
  - id: output_indexed_data
    default: true
  run: cramrecord2bamrecord.cwl.steps/samtools_index_1_9_cwl1_0.cwl
  out:
  - id: indexed_data_file
  - id: out_index
  sbg:x: 90
  sbg:y: 12
sbg:appVersion:
- v1.2
- v1.0
sbg:content_hash: afb1081e8a68fab5e6af35b2db865bbf02d600bf82e3e386218acfc391c9c445d
sbg:contributors:
- chapmano
sbg:createdBy: chapmano
sbg:createdOn: 1720830275
sbg:id: chapmano/pancancer-ecdna/cramrecord2bamrecord/10
sbg:image_url: |-
  https://cavatica.sbgenomics.com/ns/brood/images/chapmano/pancancer-ecdna/cramrecord2bamrecord/10.png
sbg:latestRevision: 10
sbg:modifiedBy: chapmano
sbg:modifiedOn: 1721242048
sbg:original_source: chapmano/pancancer-ecdna/cramrecord2bamrecord/10
sbg:project: chapmano/pancancer-ecdna
sbg:projectName: pancancer-ecDNA
sbg:publisher: sbg
sbg:revision: 10
sbg:revisionNotes: remove input command line args
sbg:revisionsInfo:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720830275
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720830544
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720831438
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720831619
  sbg:revision: 3
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720831652
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720836870
  sbg:revision: 5
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720837685
  sbg:revision: 6
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720838734
  sbg:revision: 7
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721155647
  sbg:revision: 8
  sbg:revisionNotes: require references
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721160758
  sbg:revision: 9
  sbg:revisionNotes: output_indexed_data=true
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721242048
  sbg:revision: 10
  sbg:revisionNotes: remove input command line args
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
