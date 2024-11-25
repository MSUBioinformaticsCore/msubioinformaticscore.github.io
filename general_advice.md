---
layout: post
post title: "General Advice"
date: 2024-11-25
author: "Leah Terrian"
categories: jekyll update
---

<style>
summary {
  font-size: 18px;
  font-weight: bold;
}
</style>

# Bioinformatics Tips and Tricks
Think of this like an FAQs page for bioinformatics.

<details>
<summary>Use quality metrics!</summary>

- Look for and understand quality metrics that you can judge the quality of your data and/or the success of your analysis by. For example: Use FastQC to measure the quality of your fastq sequencing files. If you have more than one sequencing file, use MultiQC to combine the FastQC reports into an easy to compare format.
</details>

<details>
<summary>Keep track of your data!</summary>

- It can be easy to lose your data as you move it between programs. Making sure you know where it is and what format it's in will save you a lot of headache. One way to keep track of your data is by adding a line like "echo output was saved as a .bam file in where/my/output/is/" to the end of a slurm script. One benefit of using a pipeline is that it will automatically handle input and output of the data for you.
</details>

<details>
<summary>Understand thresholds of significance</summary>

- Why do we use pvalue 0.05, why do we use a log2fold threshold of |1|, why do we use a FDR, etc...
</details>


### For additional help please contact us at:

- **MSU Bioinformatics Core Support**:
   - **Email**: [bioinformatics@msu.edu](mailto:bioinformatics@msu.edu)
   - **Teams Help Desk**: [Help Desk](https://teams.microsoft.com/l/channel/19%3Af754b74d5bcd403cbe02100df1062cf9%40thread.tacv2/Help_Desk?groupId=80c35f6e-1356-42a9-a8da-296129a27ff7&tenantId=22177130-642f-41d9-9211-74237ad5687d)
   - **Website**: [https://bioinformatics.msu.edu/](https://bioinformatics.msu.edu/)
- **MSU HPCC Support**:
  - **Email**: [general@rt.hpcc.msu.edu](mailto:general@rt.hpcc.msu.edu)
  - **Phone**: (517) 353-9309
  - **Website**: [https://contact.icer.msu.edu/contact](https://contact.icer.msu.edu/contact)








