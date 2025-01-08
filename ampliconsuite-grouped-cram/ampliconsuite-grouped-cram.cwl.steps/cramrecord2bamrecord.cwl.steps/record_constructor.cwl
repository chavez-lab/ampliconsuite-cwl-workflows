cwlVersion: v1.2
class: CommandLineTool
label: record-constructor
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: InlineJavascriptRequirement

inputs:
- id: sample_name
  type: string
- id: bam
  type: File
  secondaryFiles:
  - pattern: .bai
    required: false
  - pattern: .crai
    required: false
  sbg:fileTypes: BAM, CRAM, SAM
- id: tumor_normal
  type: string

outputs:
- id: output
  type:
    name: output
    type: record
    fields:
    - name: sample_name
      type: string
      outputBinding:
        outputEval: $(inputs.sample_name)
    - name: bam
      type: File
      secondaryFiles:
      - pattern: .bai
        required: false
      - pattern: .crai
        required: false
      outputBinding:
        outputEval: $(inputs.bam)
      sbg:fileTypes: BAM, SAM, CRAM
    - name: tumor_normal
      type: string
      outputBinding:
        outputEval: $(inputs.tumor_normal)

baseCommand:
- 'true'
id: chapmano/pancancer-ecdna/record-constructor/6
sbg:appVersion:
- v1.2
sbg:content_hash: a32ffaaf9ffe0de7d5cb113846068ab652ecc1aef04ff7f6ed283c6e15dfb1bc5
sbg:contributors:
- chapmano
sbg:createdBy: chapmano
sbg:createdOn: 1720826157
sbg:id: chapmano/pancancer-ecdna/record-constructor/6
sbg:image_url:
sbg:latestRevision: 6
sbg:modifiedBy: chapmano
sbg:modifiedOn: 1720837463
sbg:project: chapmano/pancancer-ecdna
sbg:projectName: pancancer-ecDNA
sbg:publisher: sbg
sbg:revision: 6
sbg:revisionNotes: add true as dummy command
sbg:revisionsInfo:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720826157
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720828105
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720828182
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720831245
  sbg:revision: 3
  sbg:revisionNotes: correct file types?
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720831578
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720831985
  sbg:revision: 5
  sbg:revisionNotes: secondary files in output
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720837463
  sbg:revision: 6
  sbg:revisionNotes: add true as dummy command
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
