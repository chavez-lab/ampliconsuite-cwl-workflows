cwlVersion: v1.2
class: Workflow
label: AmpliconSuite-grouped-pipeline
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: LoadListingRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: data_repo
  type: Directory
  loadListing: deep_listing
  sbg:x: -497
  sbg:y: 115
- id: mosek_dir
  type: Directory
  loadListing: deep_listing
  sbg:x: -583
  sbg:y: -110
- id: ref
  doc: must be 'hg19', 'GRCh37', or 'GRCh38'
  type: string?
  sbg:x: -345
  sbg:y: -271
- id: input_records
  type:
    type: array
    items:
      name: input_records
      type: record
      fields:
      - name: sample_name
        type: string
        inputBinding:
          position: 0
          shellQuote: true
      - name: bam
        type: File
        secondaryFiles:
        - pattern: .bai
          required: true
        inputBinding:
          position: 1
          shellQuote: false
      - name: tumor_normal
        doc: May only be "tumor" or "normal"
        type: string
        inputBinding:
          position: 2
          shellQuote: false
  sbg:x: -582
  sbg:y: 14
- id: cngain
  doc: Default value for this wrapper is 5. Default for AA is 4.5.
  type: float?
  sbg:x: -333.3212890625
  sbg:y: 135
- id: output_dir
  label: output_directory
  doc: Place all output files here. Recommended to name after the shared sample id.
  type: string
  sbg:x: -485
  sbg:y: -222

outputs:
- id: output
  type: File
  outputSource:
  - zip/output
  sbg:x: 357
  sbg:y: -52

steps:
- id: ampliconsuite_grouped
  label: AmpliconSuite_grouped
  in:
  - id: data_repo
    loadListing: deep_listing
    source: data_repo
  - id: mosek_dir
    loadListing: deep_listing
    source: mosek_dir
  - id: ref
    source: ref
  - id: input_records
    source:
    - input_records
  - id: output_dir
    source: output_dir
  - id: cngain
    source: cngain
  run: ampliconsuite-grouped-pipeline.cwl.steps/ampliconsuite_grouped.cwl
  out:
  - id: output
  sbg:x: -157
  sbg:y: -47
- id: zip
  label: zip
  in:
  - id: input
    loadListing: deep_listing
    source: ampliconsuite_grouped/output
  run: ampliconsuite-grouped-pipeline.cwl.steps/zip.cwl
  out:
  - id: output
  sbg:x: 143
  sbg:y: -50
sbg:appVersion:
- v1.2
sbg:content_hash: a6568dd30b3c516cc5508683b8ffa0cb5d036630006241d82dcb80416cb0aa6d1
sbg:contributors:
- chapmano
sbg:createdBy: chapmano
sbg:createdOn: 1720032593
sbg:id: chapmano/pancancer-ecdna/ampliconsuite-grouped-pipeline/12
sbg:image_url: |-
  https://cavatica.sbgenomics.com/ns/brood/images/chapmano/pancancer-ecdna/ampliconsuite-grouped-pipeline/12.png
sbg:latestRevision: 12
sbg:modifiedBy: chapmano
sbg:modifiedOn: 1721431818
sbg:original_source: |-
  https://cavatica-api.sbgenomics.com/v2/apps/chapmano/pancancer-ecdna/ampliconsuite-grouped-pipeline/12/raw/
sbg:project: chapmano/pancancer-ecdna
sbg:projectName: pancancer-ecDNA
sbg:publisher: sbg
sbg:revision: 12
sbg:revisionNotes: capture AA stdout
sbg:revisionsInfo:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720032593
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720032918
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720033292
  sbg:revision: 2
  sbg:revisionNotes: add inputs
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720212056
  sbg:revision: 3
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720213203
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720216812
  sbg:revision: 5
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720218011
  sbg:revision: 6
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720218865
  sbg:revision: 7
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720222166
  sbg:revision: 8
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720294245
  sbg:revision: 9
  sbg:revisionNotes: add .crai spec
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721156427
  sbg:revision: 10
  sbg:revisionNotes: ASG app v9
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721416589
  sbg:revision: 11
  sbg:revisionNotes: hardcode 4 threds
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721431818
  sbg:revision: 12
  sbg:revisionNotes: capture AA stdout
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
