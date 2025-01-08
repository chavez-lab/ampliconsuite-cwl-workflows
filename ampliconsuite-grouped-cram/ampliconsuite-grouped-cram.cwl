cwlVersion: v1.2
class: Workflow
label: AmpliconSuite-grouped-cram
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: LoadListingRequirement
- class: SubworkflowFeatureRequirement
- class: ScatterFeatureRequirement
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
- id: reference_file_list
  label: List of reference names and lengths
  doc: |-
    A tab-delimited file. Each line must contain the reference name in the first column and the length of the reference in the second column, with one line for each distinct reference. Any additional fields beyond the second column are ignored. This file also defines the order of the reference sequences in sorting. If you run SAMtools Faidx on reference FASTA file (<ref.fa>), the resulting index file <ref.fa>.fai can be used as this file.
  type: File?
  sbg:fileTypes: FAI, TSV, TXT
  sbg:x: -844.5852661132812
  sbg:y: -142.35055541992188
- id: in_reference
  label: Reference file
  doc: |-
    A FASTA format reference file, optionally compressed by bgzip and ideally indexed by SAMtools Faidx. If an index is not present, one will be generated for you. This file is used for compression/decompression of CRAM files. Please provide reference file when using CRAM input/output file.
  type: File?
  sbg:fileTypes: FASTA, FA, FASTA.GZ, FA.GZ, GZ
  sbg:x: -832.585205078125
  sbg:y: 179.64503479003906
- id: input_record
  type:
    type: array
    items:
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
  sbg:x: -957.9970703125
  sbg:y: 28.824352264404297

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
    - cramrecord2bamrecord/output
  - id: output_dir
    source: output_dir
  - id: cngain
    source: cngain
  run: ampliconsuite-grouped-cram.cwl.steps/ampliconsuite_grouped.cwl
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
  run: ampliconsuite-grouped-cram.cwl.steps/zip.cwl
  out:
  - id: output
  sbg:x: 143
  sbg:y: -50
- id: cramrecord2bamrecord
  label: cramrecord2bamrecord
  in:
  - id: input_record
    source: input_record
  - id: reference_file_list
    source: reference_file_list
  - id: in_reference
    source: in_reference
  scatter:
  - input_record
  run: ampliconsuite-grouped-cram.cwl.steps/cramrecord2bamrecord.cwl
  out:
  - id: output
  sbg:x: -655.2598266601562
  sbg:y: 28.056800842285156
sbg:appVersion:
- v1.2
- v1.0
sbg:content_hash: a911557f25bdd1b0b4566c851c9861f408755c835a3f950106693a1fcec1438d4
sbg:contributors:
- chapmano
sbg:createdBy: chapmano
sbg:createdOn: 1720810936
sbg:id: chapmano/pancancer-ecdna/ampliconsuite-grouped-cram/15
sbg:image_url: |-
  https://cavatica.sbgenomics.com/ns/brood/images/chapmano/pancancer-ecdna/ampliconsuite-grouped-cram/15.png
sbg:latestRevision: 15
sbg:modifiedBy: chapmano
sbg:modifiedOn: 1722285448
sbg:original_source: |-
  https://cavatica-api.sbgenomics.com/v2/apps/chapmano/pancancer-ecdna/ampliconsuite-grouped-cram/15/raw/
sbg:project: chapmano/pancancer-ecdna
sbg:projectName: pancancer-ecDNA
sbg:publisher: sbg
sbg:revision: 15
sbg:revisionNotes: --skip_AA_on_normal_bam
sbg:revisionsInfo:
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720810936
  sbg:revision: 0
  sbg:revisionNotes: Copy of chapmano/pancancer-ecdna/ampliconsuite-grouped-pipeline/9
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720813146
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720827310
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720832112
  sbg:revision: 3
  sbg:revisionNotes: scatter on input_record
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720833428
  sbg:revision: 4
  sbg:revisionNotes: array of records
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720833769
  sbg:revision: 5
  sbg:revisionNotes: specify record inputs
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720833860
  sbg:revision: 6
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720836917
  sbg:revision: 7
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720837712
  sbg:revision: 8
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1720839184
  sbg:revision: 9
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721238204
  sbg:revision: 10
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721240636
  sbg:revision: 11
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721242176
  sbg:revision: 12
  sbg:revisionNotes: ''
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721249827
  sbg:revision: 13
  sbg:revisionNotes: workflow input should be cram
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1721431842
  sbg:revision: 14
  sbg:revisionNotes: capture AA stdout
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1722285448
  sbg:revision: 15
  sbg:revisionNotes: --skip_AA_on_normal_bam
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
