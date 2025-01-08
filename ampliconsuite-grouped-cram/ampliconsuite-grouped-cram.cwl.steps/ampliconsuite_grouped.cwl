cwlVersion: v1.2
class: CommandLineTool
label: AmpliconSuite_grouped
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: LoadListingRequirement
- class: ResourceRequirement
  coresMin: 4
  ramMin: 8000
- class: DockerRequirement
  dockerPull: registry.hub.docker.com/jluebeck/prepareaa:v1.3.3
- class: InitialWorkDirRequirement
  listing:
  - writable: true
    entry: $(inputs.data_repo)
  - writable: false
    entry: $(inputs.mosek_dir)
  - entryname: input_file.txt
    writable: true
    entry: |-
      ${
          var contents = "";
          for (var i = 0; i < inputs.input_records.length; i++) {
              contents+= inputs.input_records[i].sample_name+"\t"+inputs.input_records[i].bam.path+"\t"+inputs.input_records[i].tumor_normal+"\n";
          };
          return(contents);
      }
- class: EnvVarRequirement
  envDef:
  - envName: AA_DATA_REPO
    envValue: $(inputs.data_repo.basename)
  - envName: MOSEK_DIR
    envValue: $(inputs.mosek_dir.path)
  - envName: AA_SRC
    envValue: ' /home/programs/AmpliconArchitect-master/src '
  - envName: AC_SRC
    envValue: /home/programs/AmpliconClassifier-main
- class: InlineJavascriptRequirement
- class: ToolTimeLimit
  timelimit: 259200

inputs:
- id: data_repo
  type: Directory
  loadListing: deep_listing
- id: mosek_dir
  type: Directory
  loadListing: deep_listing
- id: ref
  doc: must be 'hg19', 'GRCh37', or 'GRCh38'
  type: string?
  inputBinding:
    prefix: --ref
    position: 2
    shellQuote: false
- id: input_records
  type:
    type: array
    items:
      name: input_records
      type: record
      fields:
      - name: sample_name
        type: string
      - name: bam
        type: File
        secondaryFiles:
        - pattern: .bai
          required: false
        - pattern: .crai
          required: false
        sbg:fileTypes: .bam, .cram
      - name: tumor_normal
        doc: May only be "tumor" or "normal"
        type: string
- id: output_dir
  label: output_directory
  doc: Place all output files here. Recommended to name after the shared sample id.
  type: string
  default: output
  inputBinding:
    prefix: --output_directory
    position: 0
    shellQuote: false
- id: cngain
  doc: Default value for this wrapper is 5. Default for AA is 4.5.
  type: float?
  default: 5
  inputBinding:
    prefix: --cngain
    position: 3
    shellQuote: false

outputs:
- id: output
  type: Directory
  outputBinding:
    glob: $(inputs.output_dir)
    loadListing: deep_listing
stdout: job.stdout.log

baseCommand:
- python
- /home/programs/AmpliconSuite-pipeline-master/GroupedAnalysisAmpSuite.py
arguments:
- prefix: --rscript_path
  position: 10
  valueFrom: /usr/bin/Rscript
  shellQuote: false
- prefix: --cnvkit_dir
  position: 11
  valueFrom: /usr/local/bin
  shellQuote: false
- prefix: --python3_path
  position: 12
  valueFrom: /usr/bin/
  shellQuote: false
- prefix: --AA_src
  position: 14
  valueFrom: /home/programs/AmpliconArchitect-master/src
  shellQuote: false
- prefix: --input
  position: 0
  valueFrom: input_file.txt
  shellQuote: false
- prefix: --nthreads
  position: 2
  valueFrom: '4'
  shellQuote: false
- prefix: --skip_AA_on_normal_bam
  position: 15
  valueFrom: ' '
  shellQuote: false
id: chapmano/pancancer-ecdna/ampliconsuite-grouped/16
sbg:appVersion:
- v1.2
sbg:content_hash: af7bce160fb18faca3283ddeb2d224662cb6450453794ddc531a3c4daa1cbb4ef
sbg:contributors:
- chapmano
sbg:createdBy: chapmano
sbg:createdOn: 1719447184
sbg:id: chapmano/pancancer-ecdna/ampliconsuite-grouped/16
sbg:image_url:
sbg:latestRevision: 16
sbg:modifiedBy: chapmano
sbg:modifiedOn: 1722285410
sbg:project: chapmano/pancancer-ecdna
sbg:projectName: pancancer-ecDNA
sbg:publisher: sbg
sbg:revision: 16
sbg:revisionNotes: --skip_AA_on_normal_bam
sbg:revisionsInfo:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1719447184
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1719447766
  sbg:revision: 1
  sbg:revisionNotes: initial commit
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1719448952
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1719959983
  sbg:revision: 3
  sbg:revisionNotes: output entire directory
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1719965744
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1719967632
  sbg:revision: 5
  sbg:revisionNotes: specify input_file.txt contents
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720211982
  sbg:revision: 6
  sbg:revisionNotes: revise input js
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720213168
  sbg:revision: 7
  sbg:revisionNotes: correct path to executable
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720216777
  sbg:revision: 8
  sbg:revisionNotes: AA_SRC and AC_SRC environment variables
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720217939
  sbg:revision: 9
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720218820
  sbg:revision: 10
  sbg:revisionNotes: remove --AC_SRC arg
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720222134
  sbg:revision: 11
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720294208
  sbg:revision: 12
  sbg:revisionNotes: Add .crai pattern as secondary file
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721156374
  sbg:revision: 13
  sbg:revisionNotes: unbind record fields from command line
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721415860
  sbg:revision: 14
  sbg:revisionNotes: hardcode 4 threads
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721431780
  sbg:revision: 15
  sbg:revisionNotes: capture stdout
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1722285410
  sbg:revision: 16
  sbg:revisionNotes: --skip_AA_on_normal_bam
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
