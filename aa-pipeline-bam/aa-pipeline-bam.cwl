cwlVersion: v1.2
class: Workflow
label: AA_pipeline_from_bam
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: LoadListingRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: mosek_dir
  type: Directory
  loadListing: deep_listing
  sbg:x: 658.3834228515625
  sbg:y: 388.1197204589844
- id: data_repo
  type: Directory
  loadListing: deep_listing
  sbg:x: 692.8483276367188
  sbg:y: 554.658447265625
- id: reference
  doc: must be 'hg19' or 'hg38'
  type: string
  sbg:exposed: true
- id: in_alignments
  label: BAM/CRAM input file
  doc: BAMinput file.
  type: File
  sbg:fileTypes: BAM
  sbg:x: 458.9976501464844
  sbg:y: 261.0660400390625
- id: output_prefix
  doc: Directory path, of the format "/home/output/FILE_PREFIX"
  type: string
  sbg:exposed: true
- id: ref
  doc: must be 'hg19', 'GRCh37', or 'GRCh38'
  type: string?
  sbg:exposed: true
- id: sample_name
  type: string?
  sbg:exposed: true
- id: ref_1
  doc: GRCh37, GRCh38 or hg19
  type: string?
  sbg:exposed: true

outputs:
- id: fp
  type: File
  outputSource:
  - fingerprint/fp
  sbg:x: 1247
  sbg:y: 562.144287109375
- id: summary
  type: File
  outputSource:
  - ampliconarchitect_1/summary
  sbg:x: 1637.337158203125
  sbg:y: -125.30316925048828
- id: png
  type: File[]?
  outputSource:
  - ampliconarchitect_1/png
  sbg:x: 1634.6044921875
  sbg:y: -4.0941162109375
- id: pdf
  type: File[]?
  outputSource:
  - ampliconarchitect_1/pdf
  sbg:x: 1639.474853515625
  sbg:y: 116.89018249511719
- id: logs
  type: File[]?
  outputSource:
  - ampliconarchitect_1/logs
  sbg:x: 1636.952880859375
  sbg:y: 239.9058837890625
- id: graph
  type: File[]?
  outputSource:
  - ampliconarchitect_1/graph
  sbg:x: 1630.4097900390625
  sbg:y: 354.9698486328125
- id: edges
  type: File[]?
  outputSource:
  - ampliconarchitect_1/edges
  sbg:x: 1641.9302978515625
  sbg:y: 480.5104064941406
- id: cycles
  type: File[]?
  outputSource:
  - ampliconarchitect_1/cycles
  sbg:x: 1649.2239990234375
  sbg:y: 617.9529418945312
- id: cnseg
  type: File[]?
  outputSource:
  - ampliconarchitect_1/cnseg
  sbg:x: 1649.9827880859375
  sbg:y: 747.5235595703125
- id: seed
  type: File
  outputSource:
  - prepareaa_normal/seed
  sbg:x: 1279.0633544921875
  sbg:y: 43.7623405456543

steps:
- id: fingerprint
  label: fingerprint
  in:
  - id: bam
    source: samtools_index_1_9_cwl1_0/indexed_data_file
  - id: reference
    source: reference
  run: aa-pipeline-bam.cwl.steps/fingerprint.cwl
  out:
  - id: fp
  sbg:x: 1027.0179443359375
  sbg:y: 513.2871704101562
- id: samtools_index_1_9_cwl1_0
  label: Samtools Index CWL1.0
  in:
  - id: in_alignments
    source: in_alignments
  - id: output_indexed_data
    default: true
  - id: index_file_format
    default: BAI
  run: aa-pipeline-bam.cwl.steps/samtools_index_1_9_cwl1_0.cwl
  out:
  - id: indexed_data_file
  - id: out_index
  sbg:x: 662.2589721679688
  sbg:y: 258.8139953613281
- id: ampliconarchitect_1
  label: AmpliconArchitect
  in:
  - id: bam
    source: samtools_index_1_9_cwl1_0/indexed_data_file
  - id: bed
    source: prepareaa_normal/seed
  - id: ref
    source: ref_1
  - id: output_prefix
    source: output_prefix
  - id: data_repo
    loadListing: deep_listing
    source: data_repo
  - id: mosek_dir
    loadListing: deep_listing
    source: mosek_dir
  run: aa-pipeline-bam.cwl.steps/ampliconarchitect_1.cwl
  out:
  - id: summary
  - id: png
  - id: pdf
  - id: cycles
  - id: edges
  - id: cnseg
  - id: graph
  - id: logs
  sbg:x: 1463.5196533203125
  sbg:y: 292.6478271484375
- id: prepareaa_normal
  label: PrepareAA
  in:
  - id: data_repo
    loadListing: deep_listing
    source: data_repo
  - id: mosek_dir
    loadListing: deep_listing
    source: mosek_dir
  - id: sample_name
    source: sample_name
  - id: sorted_bam
    source: samtools_index_1_9_cwl1_0/indexed_data_file
  - id: ref
    source: ref
  run: aa-pipeline-bam.cwl.steps/prepareaa_normal.cwl
  out:
  - id: seed
  - id: cns
  - id: gain
  sbg:x: 990.2034301757812
  sbg:y: 166.7245635986328
sbg:appVersion:
- v1.2
- v1.0
sbg:content_hash: a749e63e1363dfd231ec808f2ae972e226667548c8a818fddeaae0b239ead7de4
sbg:contributors:
- adutta
sbg:createdBy: adutta
sbg:createdOn: 1633410044
sbg:id: chapmano/pancancer-ecdna/aa-pipeline-bam-index/4
sbg:image_url: |-
  https://cavatica.sbgenomics.com/ns/brood/images/chapmano/pancancer-ecdna/aa-pipeline-bam-index/4.png
sbg:latestRevision: 4
sbg:modifiedBy: adutta
sbg:modifiedOn: 1662323084
sbg:original_source: |-
  https://cavatica-api.sbgenomics.com/v2/apps/chapmano/pancancer-ecdna/aa-pipeline-bam-index/4/raw/
sbg:project: chapmano/pancancer-ecdna
sbg:projectName: pancancer-ecDNA
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: changed parameter visibility
sbg:revisionsInfo:
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1633410044
  sbg:revision: 0
  sbg:revisionNotes: Copy of chapmano/medulloblastoma-ecdna/aa-pipeline-bam-index/1
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1662322813
  sbg:revision: 1
  sbg:revisionNotes: updated to new versions
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1662322911
  sbg:revision: 2
  sbg:revisionNotes: ''
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1662322948
  sbg:revision: 3
  sbg:revisionNotes: changed output prefix
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1662323084
  sbg:revision: 4
  sbg:revisionNotes: changed parameter visibility
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
