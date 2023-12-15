## Usage of playground
In command line type:
```
python3 testit.py --version=<version_to_test> --assembly=<assembly_code_to_test> --data=<data_to_use>
```

- `<version_to_test>`       can be: `1`, `2`, `3` and `4`
- `<assembly_code_to_test>` can be `F1.s`, `F1_pipeline.s`, `pdf.s` and `pdf_pipeline.s`
- `<data_to_use>` can be: `gaussian.mem`, `noisy.mem`, `triangle.mem`

Examples:
```
python3 testit.py --version=3 --assembly=F1.s
```
```
python3 testit.py --version=2 --assembly=pdf_pipeline.s --data=gaussian.mem
```