cwlVersion: v1.2
class: CommandLineTool
label: AmpliconArchitect
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: LoadListingRequirement
- class: ResourceRequirement
  coresMin: 1
  ramMin: 8000
- class: DockerRequirement
  dockerPull: registry.hub.docker.com/jluebeck/ampliconarchitect
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
- id: bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: true
  inputBinding:
    prefix: --bam
    position: 0
    shellQuote: false
  sbg:fileTypes: BAM
- id: bed
  type: File
  inputBinding:
    prefix: --bed
    position: 1
    shellQuote: false
  sbg:fileTypes: BED
- id: ref
  doc: GRCh37, GRCh38 or hg19
  type: string?
  inputBinding:
    prefix: --ref
    position: 2
    shellQuote: false
- id: output_prefix
  doc: Directory path, of the format "/home/output/FILE_PREFIX"
  type: string
  inputBinding:
    prefix: --out
    position: 3
    shellQuote: false
- id: data_repo
  type: Directory
  loadListing: deep_listing
- id: mosek_dir
  type: Directory
  loadListing: deep_listing

outputs:
- id: summary
  type: File
  outputBinding:
    glob: '*_summary.txt'
- id: png
  type: File[]?
  outputBinding:
    glob: '*.png'
- id: pdf
  type: File[]?
  outputBinding:
    glob: '*.pdf'
- id: cycles
  type: File[]?
  outputBinding:
    glob: '*_cycles.txt'
- id: edges
  type: File[]?
  outputBinding:
    glob: '*_edges.txt'
- id: cnseg
  type: File[]?
  outputBinding:
    glob: '*_edges_cnseg.txt'
- id: graph
  type: File[]?
  outputBinding:
    glob: '*_graph.txt'
- id: logs
  type: File[]?
  outputBinding:
    glob: '*_logs.txt'

baseCommand:
- python
- /home/programs/AmpliconArchitect-master/src/AmpliconArchitect.py
id: chapmano/pancancer-ecdna/ampliconarchitect/2
sbg:appVersion:
- v1.2
sbg:content_hash: ae4eca9884efc8de65d82c6c5977ad60da7c7e7e8094be055914502a06a59fa23
sbg:contributors:
- adutta
sbg:createdBy: adutta
sbg:createdOn: 1633026184
sbg:id: chapmano/pancancer-ecdna/ampliconarchitect/2
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: adutta
sbg:modifiedOn: 1645729759
sbg:project: chapmano/pancancer-ecdna
sbg:projectName: pancancer-ecDNA
sbg:publisher: sbg
sbg:revision: 2
sbg:revisionNotes: docker changed to jluebeck/ampliconarchitect
sbg:revisionsInfo:
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1633026184
  sbg:revision: 0
  sbg:revisionNotes: Copy of chapmano/medulloblastoma-ecdna/ampliconarchitect/5
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1645677852
  sbg:revision: 1
  sbg:revisionNotes: Changed $(inputs.data_repo.path) to $(inputs.data_repo.basename)
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1645729759
  sbg:revision: 2
  sbg:revisionNotes: docker changed to jluebeck/ampliconarchitect
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
