---
layout: post
title: "Instructions for Sharing Data With the Bioinformatics Core on the MSU HPCC"
date: 2024-09-25
categories: jekyll update
---
# Instructions for Sharing Data With the Bioinformatics Core on the MSU HPCC

These step-by-step instructions are designed to help users new to Linux and High-Performance Computing (HPC) share and transfer data with the Bioinformatics Core using the Michigan State University High-Performance Computing Center (MSU HPCC).

## Prerequisites

- **MSU NetID and Password**: Ensure you have an active MSU NetID and password.
- **HPCC Account**: You must have an account on the MSU HPCC.
- **Path to Shared Directory**: You will receive this from your bioinformatics core consultant. It will look similar to "/mnt/research/bioinformaticscore/shared/panchyni/"

## Step-by-Step Guide

1. **Access the MSU HPCC through OnDemand**
   - **Note:** If you prefer to access the HPCC via ssh connection, skip to section 4.
   - Open your web browser (i.e. Chrome, Firefox, Safari, etc...).
   - Go to [https://ondemand.hpcc.msu.edu/](https://ondemand.hpcc.msu.edu/).

2. **Log In with Your MSU Credentials**
   - Under **Selected Identity Provider** ensure that **Michigan State University** is selected and click the **Log On** button.
   - Sign in with your **MSU NetID** and **password**.

3. **Access the Shell Terminal**
   - Click the **">_Development Nodes"** dropdown tab on the top of the screen.
   - Click any of the listed development nodes to enter the Terminal window.

4. **Copying Data Out of the Shared Directory (Folder)**
   - In the Terminal window, navigate to the shared directory by running (type and hit the enter key on your keyboard): **cd /path/to/shared/directory**
      - **Replace** "/path/to/shared/directory" with the path given to you by your consultant.
   - You may view a list of files within the shared directory by running: **ls -lah**
   - Copy files out of the shared directory to your HPCC account space by running: **cp file_you_want_to_copy.txt /path/to/your/HPCC/account/**
      - **Important Note:** To copy directories (folders), add **-r** after **cp** in the above command.
      - **Replace** "file_you_want_to_copy.txt" with the name of the actual file or directory you want to copy.
      - **Replace** "/path/to/your/HPCC/account/" with the path where you want to copy the file or directory (i.e. /mnt/home/yourUsername/NewDirectoryName/).
         - **Tip** For better organization, you can create a new directory to copy the shared data into. You can do this by running **cd ~/** to navigate to your home directory, then run **mkdir NewDirectoryName**. 
   - Inform your consultant when the transfer is complete so they can close access permissions.

5. **Copying Data Into the Shared Directory**
   - Locate the path to your data:
      - If your data is not already on the HPCC, you will need to [**upload your data**](./data-handling-and-storage.md).
         - If your files are less than 200MB, the easiest way to do this is through [OnDemand](https://ondemand.hpcc.msu.edu/).
            - Log on to OnDemand and click the **Files** drop down tab on the top of the screen, then click **Home Directory**. There will be a blue **Upload** button near the top right, click it, then add the files and folders that you want to upload to the HPCC, and click the green **Upload Files** button. The path to your data will then be **/mnt/home/yourUsername/** where yourUsername is your MSU NetID.
            - **Note:** For organization purposes, you may also make a new directory to upload the files into. Just make sure you know the path to your data on the HPCC (i.e. /mnt/home/yourUsername/DataToShare).
         - If your files are greater than 200MB, it will be best to use one of the options in [this guide](./data-handling-and-storage.md).
      - If your data is already on the HPCC, find the path to your data by using either OnDemand or the **ls -lah** command in the Terminal window.
   - In the terminal window type and enter this command: **cd /path/to/your/data** 
      - **Replace** "/path/to/your/data" with the actual path found by following the above step.
   - Copy your data from your HPCC account space to the shared directory location by running: **cp file_you_want_to_copy.txt /path/to/shared/directory**
      - **Important Note:** To copy directories (folders), add **-r** after **cp** in the above command.
      - **Replace** "file_you_want_to_copy.txt" with the name of the actual file or directory you want to copy.
      - **Replace** "/path/to/shared/directory" with the path given to you by your consultant.
   - Inform your consultant when the transfer is complete so they can close access permissions.

## Additional Information

### Troubleshooting
- **Do not use the mv or cp -p commands to transfer files into the shared directory.**
   - Both mv and cp -p may preserve an undesired group ownership attribute even when transferred into a research space directory with ownership and permissions configured correctly. You should use cp (or cp -r) without the -p option.
- **Permission denied**
   - After you run the **cp** command, if you get an error stating: **Permission denied**. Contact your bioinformaticscore consultant and ask them to open permissions for their shared directory.

### Getting Help

- **MSU Bioinformatics Core Support**:
   - **Email**: [bioinformatics@msu.edu](mailto:bioinformatics@msu.edu)
   - **Teams Help Desk**: [Help Desk](https://teams.microsoft.com/l/channel/19%3Af754b74d5bcd403cbe02100df1062cf9%40thread.tacv2/Help_Desk?groupId=80c35f6e-1356-42a9-a8da-296129a27ff7&tenantId=22177130-642f-41d9-9211-74237ad5687d)
   - **Website**: [https://bioinformatics.msu.edu/](https://bioinformatics.msu.edu/)
- **MSU HPCC Support**:
  - **Email**: [general@rt.hpcc.msu.edu](mailto:general@rt.hpcc.msu.edu)
  - **Phone**: (517) 353-9309
  - **Website**: [https://contact.icer.msu.edu/contact](https://contact.icer.msu.edu/contact)

## Summary

By following these steps, you should be able to transfer data to and from the bioinformatics core shared directory on the MSU HPCC efficiently. If you encounter any issues or have questions, don't hesitate to reach out to the support resources listed above.
