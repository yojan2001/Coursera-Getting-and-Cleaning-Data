<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

<title>create a joined train/test data set</title>

<script type="text/javascript">
window.onload = function() {
  var imgs = document.getElementsByTagName('img'), i, img;
  for (i = 0; i < imgs.length; i++) {
    img = imgs[i];
    // center an image if it is the only element of its parent
    if (img.parentElement.childElementCount === 1)
      img.parentElement.style.textAlign = 'center';
  }
};
</script>



<!-- MathJax scripts -->
<script type="text/javascript" src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>


<style type="text/css">
body, td {
   font-family: sans-serif;
   background-color: white;
   font-size: 13px;
}

body {
  max-width: 800px;
  margin: auto;
  padding: 1em;
  line-height: 20px;
}

tt, code, pre {
   font-family: 'DejaVu Sans Mono', 'Droid Sans Mono', 'Lucida Console', Consolas, Monaco, monospace;
}

h1 {
   font-size:2.2em;
}

h2 {
   font-size:1.8em;
}

h3 {
   font-size:1.4em;
}

h4 {
   font-size:1.0em;
}

h5 {
   font-size:0.9em;
}

h6 {
   font-size:0.8em;
}

a:visited {
   color: rgb(50%, 0%, 50%);
}

pre, img {
  max-width: 100%;
}
pre {
  overflow-x: auto;
}
pre code {
   display: block; padding: 0.5em;
}

code {
  font-size: 92%;
  border: 1px solid #ccc;
}

code[class] {
  background-color: #F8F8F8;
}

table, td, th {
  border: none;
}

blockquote {
   color:#666666;
   margin:0;
   padding-left: 1em;
   border-left: 0.5em #EEE solid;
}

hr {
   height: 0px;
   border-bottom: none;
   border-top-width: thin;
   border-top-style: dotted;
   border-top-color: #999999;
}

@media print {
   * {
      background: transparent !important;
      color: black !important;
      filter:none !important;
      -ms-filter: none !important;
   }

   body {
      font-size:12pt;
      max-width:100%;
   }

   a, a:visited {
      text-decoration: underline;
   }

   hr {
      visibility: hidden;
      page-break-before: always;
   }

   pre, blockquote {
      padding-right: 1em;
      page-break-inside: avoid;
   }

   tr, img {
      page-break-inside: avoid;
   }

   img {
      max-width: 100% !important;
   }

   @page :left {
      margin: 15mm 20mm 15mm 10mm;
   }

   @page :right {
      margin: 15mm 10mm 15mm 20mm;
   }

   p, h2, h3 {
      orphans: 3; widows: 3;
   }

   h2, h3 {
      page-break-after: avoid;
   }
}
</style>



</head>

<body>
<p>library(plyr)
setwd(&ldquo;C:/Users/abo586/Desktop/Coursera/Course Project/&rdquo;)</p>

<p>#download file and save it in the data folder, in the working directory specified above.
if(!file.exists(&ldquo;./data&rdquo;)){dir.create(&ldquo;./data&rdquo;)}
fileUrl &lt;- &ldquo;<a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip">https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip</a>&rdquo;
download.file(fileUrl,destfile=&ldquo;./data/Dataset.zip&rdquo;)</p>

<p>#unzip
unzip(zipfile=&ldquo;./data/Dataset.zip&rdquo;,exdir=&ldquo;./data&rdquo;)</p>

<p>##########################################################################
#Question 1: Merge the training and the test sets to create one data set.#
##########################################################################</p>

<p>#read the training data
trainData &lt;- read.table(&ldquo;./data/UCI HAR Dataset/train/X_train.txt&rdquo;)
trainLabel &lt;- read.table(&ldquo;./data/UCI HAR Dataset/train/y_train.txt&rdquo;)
trainSubject &lt;- read.table(&ldquo;./data/UCI HAR Dataset/train/subject_train.txt&rdquo;)</p>

<p>#read the test data
testData &lt;- read.table(&ldquo;./data/UCI HAR Dataset/test/X_test.txt&rdquo;)
testLabel &lt;- read.table(&ldquo;./data/UCI HAR Dataset/test/y_test.txt&rdquo;)
testSubject &lt;- read.table(&ldquo;./data/UCI HAR Dataset/test/subject_test.txt&rdquo;)</p>

<h1>create a joined train/test data set</h1>

<p>dataJoined &lt;- rbind(trainData, testData)
dim(dataJoined)</p>

<h1>create a joined &#39;label&#39; data set</h1>

<p>labelJoined &lt;- rbind(trainLabel, testLabel)
dim(labelJoined)</p>

<h1>create a joined &#39;subject&#39; data set</h1>

<p>subjectJoined &lt;- rbind(trainSubject, testSubject)
dim(subjectJoined)</p>

<p>#####################################################################################################
#Question 2: Extract only the measurements on the mean and standard deviation for each measurement.#
#####################################################################################################</p>

<p>features &lt;- read.table(&ldquo;./data/UCI HAR Dataset/features.txt&rdquo;)</p>

<h1>get only columns with mean() or std() in their names</h1>

<p>mean_and_std_features &lt;- grep(&ldquo;-(mean|std)\(\)&rdquo;, features[, 2])
length(mean_and_std_features)</p>

<h1>subset the desired columns</h1>

<p>dataJoined &lt;- dataJoined[, mean_and_std_features]</p>

<h1>correct the column names</h1>

<p>names(dataJoined) &lt;- features[mean_and_std_features, 2]</p>

<p>#remove &ldquo;()&rdquo;; capitalize M and S; remove &ldquo;-&rdquo; in column names.
names(dataJoined) &lt;- gsub(&ldquo;\(\)&rdquo;, &ldquo;&rdquo;, features[mean_and_std_features, 2])
names(dataJoined) &lt;- gsub(&ldquo;mean&rdquo;, &ldquo;Mean&rdquo;, names(dataJoined))
names(dataJoined) &lt;- gsub(&ldquo;std&rdquo;, &ldquo;Std&rdquo;, names(dataJoined))
names(dataJoined) &lt;- gsub(&ldquo;-&rdquo;, &ldquo;&rdquo;, names(dataJoined))</p>

<p>#####################################################################################
#Question 3: Uses descriptive activity names to name the activities in the data set.#
#####################################################################################</p>

<p>activities &lt;- read.table(&ldquo;./data/UCI HAR Dataset/activity_labels.txt&rdquo;)</p>

<h1>update values with correct activity names</h1>

<p>labelJoined[, 1] &lt;- activities[labelJoined[, 1], 2]</p>

<h1>correct column name</h1>

<p>names(labelJoined) &lt;- &ldquo;activity&rdquo;</p>

<p>################################################################################
#Question 4: Appropriately labels the data set with descriptive variable names.# 
################################################################################</p>

<p>#correct column name
names(subjectJoined) &lt;- &ldquo;subject&rdquo;</p>

<p>#create a single clean dataset
cleanData &lt;- cbind(subjectJoined, labelJoined, dataJoined)
dim(cleanData)
head(cleanData)</p>

<p>#write out a merged and cleaned dataset
write.table(cleanData, &ldquo;merged_cleaned_data.txt&rdquo;)</p>

<p>#####################################################################################</p>

<h1>Question 5:  Create a second, independent tidy data set with the average of each</h1>

<h1>variable for each activity and each subject.</h1>

<p>#####################################################################################</p>

<p>cleanData2 &lt;- aggregate(. ~subject + activity, cleanData, mean)</p>

<p>cleanData2 &lt;- cleanData2[order(cleanData2$subject, cleanData2$activity),]
write.table(cleanData2, file = &ldquo;merged_cleaned_data2.txt&rdquo;, row.name=FALSE)</p>

<p>###########################</p>

<h1>Create Codebook in knitr</h1>

<p>###########################</p>

<p>library(knitr)
knit2html(&ldquo;codebook.Rmd&rdquo;)</p>

</body>

</html>
