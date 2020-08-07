# What is what

In this folder you will find the following hosts files, which is different
combinations of the source files from the `test_results/*.active.txt` folder.

These records have been tested from the `submit_here/*.txt` with 
[PyFunceble](https://github.com/funilrys/PyFunceble)
To minimize the numbers of FP's ([False Positives](https://www.mypdns.org/w/falsepositive/))

```
download_here/
├── 0.0.0.0
│   └── hosts
├── 127.0.0.1
│   └── hosts
├── mobile
│   └── hosts
├── safesearch
│   ├── 0.0.0.0
│   │   └── hosts
│   ├── 127.0.0.1
│   │   └── hosts
│   ├── mobile
│   │   └── hosts
│   └── strict
│       ├── 0.0.0.0
│       │   └── hosts
│       └── 127.0.0.1
│           └── hosts
└── strict
    ├── 0.0.0.0
    │   └── hosts
    └── 127.0.0.1
        └── hosts
```

| Location | Combination | IP-address |
| :------: | :---------: | :--------: |
| 0.0.0.0/hosts | `hosts.txt` | 0.0.0.0 |
| 127.0.0.1/hosts | `hosts.txt` | 127.0.0.1 |
| mobile/hosts | `mobile.txt`+ `hosts.txt` | 0.0.0.0 |
| safesearch/0.0.0.0/hosts | `hosts.txt` + `safe search records` | 0.0.0.0 |
| safesearch/127.0.0.1/hosts | `hosts.txt` + `safe search records` | 127.0.0.1 |
| safesearch/mobile/hosts | `hosts.txt` + `safe search records` | 0.0.0.0 |
| safesearch/strict/0.0.0.0/hosts | `hosts.txt` + `strict_adult.txt` + `safe search records` | 0.0.0.0 |
| safesearch/strict/127.0.0.1/hosts | `hosts.txt` + `strict_adult.txt` + `safe search records` | 127.0.0.1 |
| strict/0.0.0.0/hosts | `hosts.txt` + `strict_adult.txt` | 0.0.0.0 |
| strict/127.0.0.1/hosts | `hosts.txt` + `strict_adult.txt` | 127.0.0.1 |




