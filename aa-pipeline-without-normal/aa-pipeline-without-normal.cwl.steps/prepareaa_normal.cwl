cwlVersion: v1.2
class: CommandLineTool
label: PrepareAA
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: LoadListingRequirement
- class: ResourceRequirement
  coresMin: 0
  ramMin: 8000
- class: DockerRequirement
  dockerPull: registry.hub.docker.com/jluebeck/prepareaa:v0.1203.10
- class: InitialWorkDirRequirement
  listing:
  - writable: true
    entry: $(inputs.data_repo)
  - writable: false
    entry: $(inputs.mosek_dir)
- class: EnvVarRequirement
  envDef:
  - envName: AA_DATA_REPO
    envValue: $(inputs.data_repo.basename)
  - envName: MOSEK_DIR
    envValue: $(inputs.mosek_dir.path)
- class: InlineJavascriptRequirement

inputs:
- id: data_repo
  type: Directory
  loadListing: deep_listing
- id: mosek_dir
  type: Directory
  loadListing: deep_listing
- id: sample_name
  type: string?
  inputBinding:
    prefix: -s
    position: 0
    shellQuote: false
- id: sorted_bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  inputBinding:
    prefix: --sorted_bam
    position: 1
    shellQuote: false
  sbg:fileTypes: BAM
- id: ref
  doc: must be 'hg19', 'GRCh37', or 'GRCh38'
  type: string?
  inputBinding:
    prefix: --ref
    position: 2
    shellQuote: false
- id: threads
  type: string?
  default:
  inputBinding:
    prefix: -t
    position: 0
    shellQuote: false
- id: normal
  type: File?
  secondaryFiles:
  - pattern: .bai
    required: true
  inputBinding:
    prefix: --normal_bam
    position: 4
    shellQuote: false
  sbg:fileTypes: BAM

outputs:
- id: seed
  type: File
  outputBinding:
    glob: output/*AA_CNV_SEEDS.bed
- id: cns
  type: File
  outputBinding:
    glob: output/cnvkit_output/*.cns
- id: gain
  type: File
  outputBinding:
    glob: output/cnvkit_output/*_CNV_GAIN.bed

baseCommand:
- python
- /home/programs/PrepareAA-master/PrepareAA.py
arguments:
- prefix: --cngain
  position: 3
  valueFrom: '5'
  shellQuote: false
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
- prefix: --output_directory
  position: 13
  valueFrom: $PWD/output
  shellQuote: false
- prefix: --aa_src
  position: 14
  valueFrom: /home/programs/AmpliconArchitect-master/src
  shellQuote: false
id: chapmano/pancancer-ecdna/prepareaa-normal/9
sbg:appVersion:
- v1.2
sbg:content_hash: a017e2735ef37c60bb6f541d63e72c6fa33968e9b70100643a634561a380f2fea
sbg:contributors:
- adutta
- chapmano
sbg:createdBy: adutta
sbg:createdOn: 1634926382
sbg:id: chapmano/pancancer-ecdna/prepareaa-normal/9
sbg:image_url:
sbg:latestRevision: 9
sbg:modifiedBy: adutta
sbg:modifiedOn: 1660696539
sbg:project: chapmano/pancancer-ecdna
sbg:projectName: pancancer-ecDNA
sbg:publisher: sbg
sbg:revision: 9
sbg:revisionNotes: changed docker version number
sbg:revisionsInfo:
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1634926382
  sbg:revision: 0
  sbg:revisionNotes: Copy of chapmano/pancancer-ecdna/prepareaa/0
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1634927058
  sbg:revision: 1
  sbg:revisionNotes: added normal parameter
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1634927149
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1635458163
  sbg:revision: 3
  sbg:revisionNotes: docker changed to jluebeck/prepareaa
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1635961528
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1636093668
  sbg:revision: 5
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1637021579
  sbg:revision: 6
  sbg:revisionNotes: argument order
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1645651175
  sbg:revision: 7
  sbg:revisionNotes: changed $(inputs.data_repo.path) to $(inputs.data_repo.basename)
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1660696530
  sbg:revision: 8
  sbg:revisionNotes: changed docker version number
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1660696539
  sbg:revision: 9
  sbg:revisionNotes: changed docker version number
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
