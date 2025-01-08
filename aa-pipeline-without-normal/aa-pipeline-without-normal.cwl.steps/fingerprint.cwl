cwlVersion: v1.0
class: CommandLineTool
label: fingerprint
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 1
- class: DockerRequirement
  dockerPull: registry.hub.docker.com/auberginekenobi/fingerprint:latest

inputs:
- id: bam
  doc: hg19 or hg38 bam file.
  type: File
  secondaryFiles:
  - .bai
  inputBinding:
    position: 0
    shellQuote: false
  sbg:fileTypes: BAM
- id: reference
  doc: must be 'hg19' or 'hg38'
  type: string
  inputBinding:
    position: 1
    shellQuote: false

outputs:
- id: fp
  type: File
  outputBinding:
    glob: '*.fp'

baseCommand:
- /app/fingerprint.sh
id: chapmano/medulloblastoma-ecdna/fingerprint/11
sbg:appVersion:
- v1.0
sbg:content_hash: a5b150f3b74da55f62f5ac221e115091ad4c8c2a39134e2639f68a4135e1a158e
sbg:contributors:
- chapmano
sbg:createdBy: chapmano
sbg:createdOn: 1593472716
sbg:id: chapmano/medulloblastoma-ecdna/fingerprint/11
sbg:image_url:
sbg:latestRevision: 11
sbg:modifiedBy: chapmano
sbg:modifiedOn: 1597047422
sbg:project: chapmano/medulloblastoma-ecdna
sbg:projectName: Medulloblastoma ecDNA
sbg:publisher: sbg
sbg:revision: 11
sbg:revisionNotes: bai as secondary file
sbg:revisionsInfo:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1593472716
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1593473773
  sbg:revision: 1
  sbg:revisionNotes: 1st commit
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1593474032
  sbg:revision: 2
  sbg:revisionNotes: bam required
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1593475385
  sbg:revision: 3
  sbg:revisionNotes: fp file output
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1593553612
  sbg:revision: 4
  sbg:revisionNotes: io configured
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1594680543
  sbg:revision: 5
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1594682098
  sbg:revision: 6
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1594927559
  sbg:revision: 7
  sbg:revisionNotes: CWL for updated fingerprint
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1594928798
  sbg:revision: 8
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1594930284
  sbg:revision: 9
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1594930681
  sbg:revision: 10
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1597047422
  sbg:revision: 11
  sbg:revisionNotes: bai as secondary file
sbg:sbgMaintained: false
sbg:validationErrors: []
