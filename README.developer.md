## To download cwl code using `sbpull`
Requirements:
- `sbpack`: `pip install sbpack cwlformat`[^1]
- An auth token at `~/.sevenbridges/credentials`. Mine looks like:
```
[cavatica]
api_endpoint = https://cavatica-api.sbgenomics.com/v2
auth_token = [my auth token]
```
Usage:
```
sbpull --unpack cavatica chapmano/pancancer-ecdna/ampliconsuite-grouped-cram ampliconsuite-grouped-cram.cwl
```
[^1]: Note that as of 2025-01-07, the developers' recommended method of installing `sbpack` using `pipx` broken due to a missing `cwlformat` dependency. See https://github.com/rabix/sbpack/issues/101.