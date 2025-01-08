cwlVersion: v1.2
class: Workflow
label: AA_pipeline_with_normal
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
  sbg:x: 730.1049194335938
  sbg:y: 413.7732849121094
- id: data_repo
  type: Directory
  loadListing: deep_listing
  sbg:x: 726.6463623046875
  sbg:y: 543.2538452148438
- id: reference
  doc: must be 'hg19' or 'hg38'
  type: string
  sbg:exposed: true
- id: in_alignments
  label: Input BAM/SAM/CRAM file
  doc: Input BAM/SAM/CRAM file.
  type: File
  sbg:fileTypes: BAM, SAM, CRAM
  sbg:x: -105.48567962646484
  sbg:y: 677.5297241210938
- id: in_index
  label: Index file
  doc: This tool requires index file for some use cases.
  type: File?
  sbg:fileTypes: BAI, CRAI, CSI
  sbg:x: -100.29785919189453
  sbg:y: 490.9831237792969
- id: in_reference
  label: Reference file
  doc: |-
    A FASTA format reference file, optionally compressed by bgzip and ideally indexed by SAMtools Faidx. If an index is not present, one will be generated for you. This file is used for compression/decompression of CRAM files. Please provide reference file when using CRAM input/output file.
  type: File?
  sbg:fileTypes: FASTA, FA, FASTA.GZ, FA.GZ, GZ
  sbg:x: -103.75640869140625
  sbg:y: 320
- id: reference_file_list
  label: List of reference names and lengths
  doc: |-
    A tab-delimited file. Each line must contain the reference name in the first column and the length of the reference in the second column, with one line for each distinct reference. Any additional fields beyond the second column are ignored. This file also defines the order of the reference sequences in sorting. If you run SAMtools Faidx on reference FASTA file (<ref.fa>), the resulting index file <ref.fa>.fai can be used as this file.
  type: File?
  sbg:fileTypes: FAI, TSV, TXT
  sbg:x: -103.75640106201172
  sbg:y: 109.24359893798828
- id: in_index_1
  label: Normal Index File
  doc: This tool requires index file for some use cases.
  type: File?
  sbg:fileTypes: BAI, CRAI, CSI
  sbg:x: 287.14892578125
  sbg:y: 129.72927856445312
- id: in_alignments_1
  label: Input Normal BAM/CRAM/SAM File
  doc: Input BAM/SAM/CRAM file.
  type: File?
  sbg:fileTypes: BAM, SAM, CRAM
  sbg:x: 287.7952575683594
  sbg:y: 258.31475830078125
- id: ref_1
  doc: GRCh37, GRCh38 or hg19
  type: string?
  sbg:exposed: true
- id: output_prefix
  doc: Directory path, of the format "/home/output/FILE_PREFIX"
  type: string
  sbg:exposed: true
- id: sample_name
  type: string?
  sbg:exposed: true
- id: ref
  doc: must be 'hg19', 'GRCh37', or 'GRCh38'
  type: string?
  sbg:exposed: true

outputs:
- id: summary
  type: File
  outputSource:
  - ampliconarchitect_1/summary
  sbg:x: 1518.986328125
  sbg:y: 0
- id: png
  type: File[]?
  outputSource:
  - ampliconarchitect_1/png
  sbg:x: 1518.986328125
  sbg:y: 106.9375
- id: pdf
  type: File[]?
  outputSource:
  - ampliconarchitect_1/pdf
  sbg:x: 1518.986328125
  sbg:y: 213.875
- id: logs
  type: File[]?
  outputSource:
  - ampliconarchitect_1/logs
  sbg:x: 1519.638916015625
  sbg:y: 323.2779235839844
- id: edges
  type: File[]?
  outputSource:
  - ampliconarchitect_1/edges
  sbg:x: 1522.331787109375
  sbg:y: 543.3949584960938
- id: graph
  type: File[]?
  outputSource:
  - ampliconarchitect_1/graph
  sbg:x: 1522.9168701171875
  sbg:y: 431.9169006347656
- id: cycles
  type: File[]?
  outputSource:
  - ampliconarchitect_1/cycles
  sbg:x: 1517.84375
  sbg:y: 656.9508056640625
- id: cnseg
  type: File[]?
  outputSource:
  - ampliconarchitect_1/cnseg
  sbg:x: 1520.077880859375
  sbg:y: 774.3896484375
- id: fp
  type: File
  outputSource:
  - fingerprint/fp
  sbg:x: 1247.72265625
  sbg:y: 325.28125
- id: seed
  type: File
  outputSource:
  - prepareaa_normal/seed
  sbg:x: 1202.492431640625
  sbg:y: 190.25376892089844

steps:
- id: fingerprint
  label: fingerprint
  in:
  - id: bam
    source: samtools_index_1_9_cwl1_0/indexed_data_file
  - id: reference
    source: reference
  run: aa-pipeline-with-normal.cwl.steps/fingerprint.cwl
  out:
  - id: fp
  sbg:x: 1038.48828125
  sbg:y: 427.75
- id: samtools_index_1_9_cwl1_0
  label: Samtools Index CWL1.0
  in:
  - id: in_alignments
    source: samtools_view_1_9_cwl1_0/out_alignments
  - id: output_indexed_data
    default: true
  - id: index_file_format
    default: BAI
  run: aa-pipeline-with-normal.cwl.steps/samtools_index_1_9_cwl1_0.cwl
  out:
  - id: indexed_data_file
  - id: out_index
  sbg:x: 723.1878051757812
  sbg:y: 268.6463623046875
- id: samtools_view_1_9_cwl1_0
  label: Samtools View CWL1.0
  in:
  - id: in_index
    source: in_index
  - id: output_format
    default: BAM
  - id: fast_bam_compression
    default: true
  - id: include_header
    default: true
  - id: in_reference
    source: in_reference
  - id: reference_file_list
    source: reference_file_list
  - id: in_alignments
    source: in_alignments
  run: aa-pipeline-with-normal.cwl.steps/samtools_view_1_9_cwl1_0.cwl
  out:
  - id: out_alignments
  - id: reads_not_selected_by_filters
  - id: alignement_count
  sbg:x: 261.0220031738281
  sbg:y: 406.60748291015625
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
  - id: threads
    default: '8'
  - id: normal
    source: samtools_index_1_9_cwl1_1/indexed_data_file
  run: aa-pipeline-with-normal.cwl.steps/prepareaa_normal.cwl
  out:
  - id: seed
  - id: cns
  - id: gain
  sbg:x: 1003.7616577148438
  sbg:y: 302.8462829589844
- id: samtools_view_1_9_cwl1_1
  label: Samtools View CWL1.0
  in:
  - id: in_index
    source: in_index_1
  - id: output_format
    default: BAM
  - id: fast_bam_compression
    default: true
  - id: include_header
    default: true
  - id: in_reference
    source: in_reference
  - id: reference_file_list
    source: reference_file_list
  - id: in_alignments
    source: in_alignments_1
  run: aa-pipeline-with-normal.cwl.steps/samtools_view_1_9_cwl1_1.cwl
  out:
  - id: out_alignments
  - id: reads_not_selected_by_filters
  - id: alignement_count
  sbg:x: 477.1878356933594
  sbg:y: 15.480554580688477
- id: samtools_index_1_9_cwl1_1
  label: Samtools Index CWL1.0
  in:
  - id: in_alignments
    source: samtools_view_1_9_cwl1_1/out_alignments
  - id: output_indexed_data
    default: true
  - id: index_file_format
    default: BAI
  run: aa-pipeline-with-normal.cwl.steps/samtools_index_1_9_cwl1_1.cwl
  out:
  - id: indexed_data_file
  - id: out_index
  sbg:x: 753.6463623046875
  sbg:y: 16.800416946411133
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
  run: aa-pipeline-with-normal.cwl.steps/ampliconarchitect_1.cwl
  out:
  - id: summary
  - id: png
  - id: pdf
  - id: cycles
  - id: edges
  - id: cnseg
  - id: graph
  - id: logs
  sbg:x: 1238.130615234375
  sbg:y: 473.09307861328125
sbg:appVersion:
- v1.2
- v1.0
sbg:content_hash: a9fca94cb7185065277ad8873f3977661ce8ba3db073cc12a2b5b791a650af605
sbg:contributors:
- chapmano
- adutta
sbg:createdBy: adutta
sbg:createdOn: 1634926182
sbg:id: chapmano/pancancer-ecdna/aa-pipeline-with-normal/12
sbg:image_url: |-
  https://cavatica.sbgenomics.com/ns/brood/images/chapmano/pancancer-ecdna/aa-pipeline-with-normal/12.png
sbg:latestRevision: 12
sbg:modifiedBy: adutta
sbg:modifiedOn: 1671165968
sbg:original_source: |-
  https://cavatica-api.sbgenomics.com/v2/apps/chapmano/pancancer-ecdna/aa-pipeline-with-normal/12/raw/
sbg:project: chapmano/pancancer-ecdna
sbg:projectName: pancancer-ecDNA
sbg:publisher: sbg
sbg:revision: 12
sbg:revisionNotes: update prepareaa version
sbg:revisionsInfo:
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1634926182
  sbg:revision: 0
  sbg:revisionNotes: Copy of chapmano/pancancer-ecdna/aa-pipeline/0
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1634926323
  sbg:revision: 1
  sbg:revisionNotes: ''
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1634927566
  sbg:revision: 2
  sbg:revisionNotes: added prepareaa with normal
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1636093614
  sbg:revision: 3
  sbg:revisionNotes: ''
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1636132345
  sbg:revision: 4
  sbg:revisionNotes: ''
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1636743976
  sbg:revision: 5
  sbg:revisionNotes: added normal through samtools view and index to prepareaa
- sbg:modifiedBy: chapmano
  sbg:modifiedOn: 1637022277
  sbg:revision: 6
  sbg:revisionNotes: update PrepareAA to v6
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1645651253
  sbg:revision: 7
  sbg:revisionNotes: updated prepareaa to latest version
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1645680328
  sbg:revision: 8
  sbg:revisionNotes: changed ampliconarchitect version
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1645681376
  sbg:revision: 9
  sbg:revisionNotes: fixed output prefix
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1645729800
  sbg:revision: 10
  sbg:revisionNotes: ampliconarchitect updated to latest version
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1646123368
  sbg:revision: 11
  sbg:revisionNotes: fixed normal settings
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1671165968
  sbg:revision: 12
  sbg:revisionNotes: update prepareaa version
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
