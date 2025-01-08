cwlVersion: v1.2
class: CommandLineTool
label: zip
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: LoadListingRequirement
- class: DockerRequirement
  dockerPull: registry.hub.docker.com/joshkeegan/zip:latest
- class: InlineJavascriptRequirement

inputs:
- id: input
  type: Directory
  inputBinding:
    position: 2
    shellQuote: false
  loadListing: deep_listing

outputs:
- id: output
  type: File
  outputBinding:
    glob: $(inputs.input.basename).zip

baseCommand:
- zip
arguments:
- prefix: -r
  position: 0
  valueFrom: ' '
  shellQuote: false
- prefix: ''
  position: 1
  valueFrom: $(inputs.input.basename).zip
  shellQuote: false
id: chapmano/pancancer-ecdna/zip/0
sbg:appVersion:
- v1.2
sbg:content_hash: ae71a6583df1af71c05d4ad053d04ce96ee7a97ff6f8b36c97e2ebb596735b78e
sbg:contributors:
- chapmano
sbg:copyOf: chapmano/pancancer-ecdna/gzip/7
sbg:createdBy: chapmano
sbg:createdOn: 1720032251
sbg:id: chapmano/pancancer-ecdna/zip/0
sbg:image_url:
sbg:latestRevision: 0
sbg:modifiedBy: chapmano
sbg:modifiedOn: 1720032251
sbg:project: chapmano/pancancer-ecdna
sbg:projectName: pancancer-ecDNA
sbg:publisher: sbg
sbg:revision: 0
sbg:revisionNotes: Copy of chapmano/pancancer-ecdna/gzip/7
sbg:revisionsInfo:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720032251
  sbg:revision: 0
  sbg:revisionNotes: Copy of chapmano/pancancer-ecdna/gzip/7
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
