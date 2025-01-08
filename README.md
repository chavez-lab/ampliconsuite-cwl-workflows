# ampliconsuite-cwl-workflow
CWL workflow and constituent tools to run [AmpliconSuite](https://github.com/AmpliconSuite/AmpliconSuite-pipeline) on sbg platforms including CAVATICA.

## Contents
Note that folder names may change slightly from the names of the workflows within.

**aa-pipeline-bam**. Run AmpliconSuite (PrepareAA, AmpliconArchitect, and AmpliconClassifier) from a .bam input file. Implemented as distinct tools because this workflow predates AmpliconSuite-pipeline.

**aa-pipeline-without-normal**. Same as above, but on a .cram input file. Under the hood, this is an extra couple of calls to `samtools` to convert and index .cram to .bam.

**aa-pipeline-with-normal**. Same as above, but accepts a .cram file for matched normal blood WGS. Under the hood, this gives better copy number calls and fewer false positives.

**ampliconsuite-grouped-bam**. Runs [AmpliconSuite in grouped analysis mode](https://github.com/AmpliconSuite/AmpliconSuite-pipeline?tab=readme-ov-file#--grouped-analysis-of-related-samples-groupedanalysisampsuitepy). This mode performs copy number calling on a set of related tumor samples (longitudinal biopsies, matched cell lines, model passages, etc.) and then runs AmpliconArchitect on the same set of seed regions for all samples. Good for looking for an ecDNA which you think may be present in a sample even if amplification is not detected. Accepts .bam inputs.

**ampliconsuite-grouped-cram**. Same as above, but accepts .cram inputs.

## Developer's Note
 Tool and workflow development was done on the CAVATICA platform and uploaded to GitHub using `sbpack`[^1]. This development pattern has some unfortunate consequences:
 - Version history is embedded in the files and not in git version control;
 - Lots of code in this repository is duplicated; for example, `zip.cwl` is a single tool developed on the CAVATICA platform, but is duplicated into each workflow here;
 - Code updates on the platform are not automatically propagated to this repository.
For these reasons, code is provided as-is for archival purposes. The code for this project is relatively stable, so we don't expect these to be major issues. However, we do recommend you copy the code snippets or paradigms you need rather than forking this project wholesale.

[^1]:https://docs.cavatica.org/docs/maintaining-and-versioning-cwl-on-external-tool-repositories