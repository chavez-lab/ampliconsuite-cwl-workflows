cwlVersion: v1.2
class: CommandLineTool
label: record-deconstructor
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: InlineJavascriptRequirement

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
      sbg:fileTypes: CRAM
    - name: tumor_normal
      doc: May only be "tumor" or "normal"
      type: string

outputs:
- id: sample_name
  type: string
  outputBinding:
    outputEval: $(inputs.input_record.sample_name)
- id: cram
  type: File
  secondaryFiles:
  - pattern: .crai
    required: true
  outputBinding:
    outputEval: $(inputs.input_record.cram)
  sbg:fileTypes: CRAM
- id: tumor_normal
  type: string
  outputBinding:
    outputEval: $(inputs.input_record.tumor_normal)

baseCommand: []
id: chapmano/pancancer-ecdna/record-deconstructor/7
sbg:appVersion:
- v1.2
sbg:content_hash: a209a351d86b0791c8d8cf117bf22283fcb699c8280155c38be74efc79f4b2db0
sbg:contributors:
- chapmano
sbg:createdBy: chapmano
sbg:createdOn: 1720826346
sbg:id: chapmano/pancancer-ecdna/record-deconstructor/7
sbg:image_url:
sbg:latestRevision: 7
sbg:modifiedBy: chapmano
sbg:modifiedOn: 1721160671
sbg:project: chapmano/pancancer-ecdna
sbg:projectName: pancancer-ecDNA
sbg:publisher: sbg
sbg:revision: 7
sbg:revisionNotes: sample_name as () not {}
sbg:revisionsInfo:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720826346
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720827297
  sbg:revision: 1
  sbg:revisionNotes: will this work
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720830530
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720837495
  sbg:revision: 3
  sbg:revisionNotes: add true as dummy command
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720837562
  sbg:revision: 4
  sbg:revisionNotes: add true as dummy command
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720837596
  sbg:revision: 5
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720838485
  sbg:revision: 6
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721160671
  sbg:revision: 7
  sbg:revisionNotes: sample_name as () not {}
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
