cwlVersion: v1.2
class: Workflow
label: AA_pipeline_without_normal
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
  sbg:x: 718.8367919921875
  sbg:y: 374.28125
- id: data_repo
  type: Directory
  loadListing: deep_listing
  sbg:x: 718.8367919921875
  sbg:y: 481.21875
- id: reference
  doc: must be 'hg19' or 'hg38'
  type: string
  sbg:exposed: true
- id: in_alignments
  label: Input BAM/SAM/CRAM file
  doc: Input BAM/SAM/CRAM file.
  type: File
  sbg:fileTypes: BAM, SAM, CRAM
  sbg:x: 0
  sbg:y: 534.6875
- id: in_index
  label: Index file
  doc: This tool requires index file for some use cases.
  type: File?
  sbg:fileTypes: BAI, CRAI, CSI
  sbg:x: 0
  sbg:y: 427.75
- id: in_reference
  label: Reference file
  doc: |-
    A FASTA format reference file, optionally compressed by bgzip and ideally indexed by SAMtools Faidx. If an index is not present, one will be generated for you. This file is used for compression/decompression of CRAM files. Please provide reference file when using CRAM input/output file.
  type: File?
  sbg:fileTypes: FASTA, FA, FASTA.GZ, FA.GZ, GZ
  sbg:x: 0
  sbg:y: 320.8125
- id: reference_file_list
  label: List of reference names and lengths
  doc: |-
    A tab-delimited file. Each line must contain the reference name in the first column and the length of the reference in the second column, with one line for each distinct reference. Any additional fields beyond the second column are ignored. This file also defines the order of the reference sequences in sorting. If you run SAMtools Faidx on reference FASTA file (<ref.fa>), the resulting index file <ref.fa>.fai can be used as this file.
  type: File?
  sbg:fileTypes: FAI, TSV, TXT
  sbg:x: 0
  sbg:y: 213.875
- id: ref
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
- id: ref_1
  doc: must be 'hg19', 'GRCh37', or 'GRCh38'
  type: string?
  sbg:exposed: true

outputs:
- id: fp
  type: File
  outputSource:
  - fingerprint/fp
  sbg:x: 1176.4351806640625
  sbg:y: 798.1050415039062
- id: seed
  type: File
  outputSource:
  - prepareaa_normal/seed
  sbg:x: 1216.1824951171875
  sbg:y: 177.88568115234375
- id: summary
  type: File
  outputSource:
  - ampliconarchitect_1/summary
  sbg:x: 1524.7685546875
  sbg:y: 146.85350036621094
- id: png
  type: File[]?
  outputSource:
  - ampliconarchitect_1/png
  sbg:x: 1524.96337890625
  sbg:y: 266.0694274902344
- id: pdf
  type: File[]?
  outputSource:
  - ampliconarchitect_1/pdf
  sbg:x: 1524.2930908203125
  sbg:y: 382.8046569824219
- id: logs
  type: File[]?
  outputSource:
  - ampliconarchitect_1/logs
  sbg:x: 1525.5123291015625
  sbg:y: 496.767822265625
- id: graph
  type: File[]?
  outputSource:
  - ampliconarchitect_1/graph
  sbg:x: 1526.5611572265625
  sbg:y: 616.7798461914062
- id: cnseg
  type: File[]?
  outputSource:
  - ampliconarchitect_1/cnseg
  sbg:x: 1530.18408203125
  sbg:y: 967.1231689453125
- id: cycles
  type: File[]?
  outputSource:
  - ampliconarchitect_1/cycles
  sbg:x: 1528.6837158203125
  sbg:y: 852.853515625
- id: edges
  type: File[]?
  outputSource:
  - ampliconarchitect_1/edges
  sbg:x: 1525.8536376953125
  sbg:y: 736.7911376953125

steps:
- id: fingerprint
  label: fingerprint
  in:
  - id: bam
    source: samtools_index_1_9_cwl1_0/indexed_data_file
  - id: reference
    source: reference
  run: aa-pipeline-without-normal.cwl.steps/fingerprint.cwl
  out:
  - id: fp
  sbg:x: 978.661376953125
  sbg:y: 649.920654296875
- id: samtools_index_1_9_cwl1_0
  label: Samtools Index CWL1.0
  in:
  - id: in_alignments
    source: samtools_view_1_9_cwl1_0/out_alignments
  - id: output_indexed_data
    default: true
  - id: index_file_format
    default: BAI
  run: aa-pipeline-without-normal.cwl.steps/samtools_index_1_9_cwl1_0.cwl
  out:
  - id: indexed_data_file
  - id: out_index
  sbg:x: 718.8367919921875
  sbg:y: 260.34375
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
  - id: subsample_fraction
    default: 47.2
  - id: in_reference
    source: in_reference
  - id: reference_file_list
    source: reference_file_list
  - id: in_alignments
    source: in_alignments
  run: aa-pipeline-without-normal.cwl.steps/samtools_view_1_9_cwl1_0.cwl
  out:
  - id: out_alignments
  - id: reads_not_selected_by_filters
  - id: alignement_count
  sbg:x: 242.75
  sbg:y: 353.28125
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
    source: ref_1
  - id: threads
    default: '8'
  run: aa-pipeline-without-normal.cwl.steps/prepareaa_normal.cwl
  out:
  - id: seed
  - id: cns
  - id: gain
  sbg:x: 1064
  sbg:y: 305.9203186035156
- id: ampliconarchitect_1
  label: AmpliconArchitect
  in:
  - id: bam
    source: samtools_index_1_9_cwl1_0/indexed_data_file
  - id: bed
    source: prepareaa_normal/seed
  - id: ref
    source: ref
  - id: output_prefix
    source: output_prefix
  - id: data_repo
    loadListing: deep_listing
    source: data_repo
  - id: mosek_dir
    loadListing: deep_listing
    source: mosek_dir
  run: aa-pipeline-without-normal.cwl.steps/ampliconarchitect_1.cwl
  out:
  - id: summary
  - id: png
  - id: pdf
  - id: cycles
  - id: edges
  - id: cnseg
  - id: graph
  - id: logs
  sbg:x: 1289.5189208984375
  sbg:y: 487.3962097167969
sbg:appVersion:
- v1.2
- v1.0
sbg:content_hash: a65dcfdad96c165671ec74d8f465d20778422e8a09f542cd3498cf44cf25ca62a
sbg:contributors:
- adutta
sbg:createdBy: adutta
sbg:createdOn: 1646170277
sbg:id: chapmano/pancancer-ecdna/aa-pipeline-without-normal/5
sbg:image_url: |-
  https://cavatica.sbgenomics.com/ns/brood/images/chapmano/pancancer-ecdna/aa-pipeline-without-normal/5.png
sbg:latestRevision: 5
sbg:modifiedBy: adutta
sbg:modifiedOn: 1671166035
sbg:original_source: |-
  https://cavatica-api.sbgenomics.com/v2/apps/chapmano/pancancer-ecdna/aa-pipeline-without-normal/5/raw/
sbg:project: chapmano/pancancer-ecdna
sbg:projectName: pancancer-ecDNA
sbg:publisher: sbg
sbg:revision: 5
sbg:revisionNotes: update paa version
sbg:revisionsInfo:
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1646170277
  sbg:revision: 0
  sbg:revisionNotes: Copy of chapmano/pancancer-ecdna/aa-pipeline/0
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1646170627
  sbg:revision: 1
  sbg:revisionNotes: added new apps
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1646206521
  sbg:revision: 2
  sbg:revisionNotes: fixed connections for aa and paa
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1646206765
  sbg:revision: 3
  sbg:revisionNotes: Fixed aa and paa inputs
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1646242546
  sbg:revision: 4
  sbg:revisionNotes: change paa inputs
- sbg:modifiedBy: adutta
  sbg:modifiedOn: 1671166035
  sbg:revision: 5
  sbg:revisionNotes: update paa version
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:workflowLanguage: CWL
