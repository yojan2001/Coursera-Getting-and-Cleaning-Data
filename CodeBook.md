<div id="header">
<h1 class="title">CODEBOOK.md</h1>
<h4 class="date"><em>Friday, June 05, 2015</em></h4>
</div>


<p>Instructions for the project:</p>
<p>The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.</p>
<p>One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:</p>
<p><a href="http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones">http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones</a></p>
<p>Here are the data for the project:</p>
<p><a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip">https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip</a></p>
<p>You should create one R script called run_analysis.R that does the following.</p>
<ol style="list-style-type: decimal">
<li>Merges the training and the test sets to create one data set.</li>
<li>Extracts only the measurements on the mean and standard deviation for each measurement.</li>
<li>Uses descriptive activity names to name the activities in the data set</li>
<li>Appropriately labels the data set with descriptive variable names.</li>
<li>From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.</li>
</ol>
<div id="step-1.-downloading-and-setting-up-the-data.-loading-the-plyr-package." class="section level4">
<h4>Step 1. Downloading and Setting up the data. Loading the plyr package.</h4>
<pre class="r"><code>setwd(&quot;C:/Users/abo586/Desktop/Coursera/Course Project/&quot;)

#download file and save it in the data folder, in the working directory specified above.
if(!file.exists(&quot;./data&quot;)){dir.create(&quot;./data&quot;)}
fileUrl &lt;- &quot;https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip&quot;
download.file(fileUrl,destfile=&quot;./data/Dataset.zip&quot;, method=&quot;curl&quot;)

#unzip
unzip(zipfile=&quot;./data/Dataset.zip&quot;,exdir=&quot;./data&quot;)</code></pre>
</div>
<div id="step-2.-loading-packages" class="section level4">
<h4>Step 2. Loading packages</h4>
<pre class="r"><code>library(dplyr)
library(data.table)
library(tidyr)</code></pre>
</div>
<div id="task-1-merge-the-training-and-the-test-sets-to-create-one-data-set." class="section level3">
<h3>Task 1: Merge the training and the test sets to create one data set.</h3>
<pre class="r"><code>#read the training data
trainData &lt;- read.table(&quot;./data/UCI HAR Dataset/train/X_train.txt&quot;)
trainLabel &lt;- read.table(&quot;./data/UCI HAR Dataset/train/y_train.txt&quot;)
trainSubject &lt;- read.table(&quot;./data/UCI HAR Dataset/train/subject_train.txt&quot;)

#read the test data
testData &lt;- read.table(&quot;./data/UCI HAR Dataset/test/X_test.txt&quot;)
testLabel &lt;- read.table(&quot;./data/UCI HAR Dataset/test/y_test.txt&quot;)
testSubject &lt;- read.table(&quot;./data/UCI HAR Dataset/test/subject_test.txt&quot;)

# create a joined train/test data set
dataJoined &lt;- rbind(trainData, testData)
dim(dataJoined)

# create a joined 'label' data set
labelJoined &lt;- rbind(trainLabel, testLabel)
dim(labelJoined)

# create a joined 'subject' data set
subjectJoined &lt;- rbind(trainSubject, testSubject)
dim(subjectJoined)</code></pre>
</div>
<div id="task-2-extract-only-the-measurements-on-the-mean-and-standard-deviation-for-each-measurement." class="section level3">
<h3>Task 2: Extract only the measurements on the mean and standard deviation for each measurement.</h3>
<pre class="r"><code>features &lt;- read.table(&quot;./data/UCI HAR Dataset/features.txt&quot;)

# get only columns with mean() or std() in their names
mean_and_std_features &lt;- grep(&quot;-(mean|std)\\(\\)&quot;, features[, 2])
length(mean_and_std_features)

# subset the desired columns
dataJoined &lt;- dataJoined[, mean_and_std_features]

# correct the column names
names(dataJoined) &lt;- features[mean_and_std_features, 2]

#remove &quot;()&quot;; capitalize M and S; remove &quot;-&quot; in column names.
names(dataJoined) &lt;- gsub(&quot;\\(\\)&quot;, &quot;&quot;, features[mean_and_std_features, 2])
names(dataJoined) &lt;- gsub(&quot;mean&quot;, &quot;Mean&quot;, names(dataJoined))
names(dataJoined) &lt;- gsub(&quot;std&quot;, &quot;Std&quot;, names(dataJoined))
names(dataJoined) &lt;- gsub(&quot;-&quot;, &quot;&quot;, names(dataJoined))</code></pre>
</div>
<div id="task-3-use-descriptive-activity-names-to-name-the-activities-in-the-data-set." class="section level3">
<h3>Task 3: Use descriptive activity names to name the activities in the data set.</h3>
<pre class="r"><code>activities &lt;- read.table(&quot;./data/UCI HAR Dataset/activity_labels.txt&quot;)

# update values with correct activity names
labelJoined[, 1] &lt;- activities[labelJoined[, 1], 2]

# correct column name
names(labelJoined) &lt;- &quot;activity&quot;</code></pre>
</div>
<div id="task-4-appropriately-label-the-data-set-with-descriptive-variable-names." class="section level3">
<h3>Task 4: Appropriately label the data set with descriptive variable names.</h3>
<pre class="r"><code>#correct column name
names(subjectJoined) &lt;- &quot;subject&quot;

#create a single clean dataset
cleanData &lt;- cbind(subjectJoined, labelJoined, dataJoined)
dim(cleanData)
head(cleanData)

#write out a merged and cleaned dataset
write.table(cleanData, &quot;merged_cleaned_data.txt&quot;)</code></pre>
</div>
<div id="task-5-create-a-second-independent-tidy-data-set-with-the-average-of-each-variable-for-each-activity-and-each-subject." class="section level3">
<h3>Task 5: Create a second, independent tidy data set with the average of each variable for each activity and each subject.</h3>
<pre class="r"><code>cleanData2 &lt;- aggregate(. ~subject + activity, cleanData, mean)

cleanData2 &lt;- cleanData2[order(cleanData2$subject, cleanData2$activity),]
write.table(cleanData2, file = &quot;merged_cleaned_data2.txt&quot;, row.name=FALSE)</code></pre>
</div>


</div>

<script>

// add bootstrap table styles to pandoc tables
$(document).ready(function () {
  $('tr.header').parent('thead').parent('table').addClass('table table-condensed');
});

</script>

<!-- dynamically load mathjax for compatibility with self-contained -->
<script>
  (function () {
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src  = "https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML";
    document.getElementsByTagName("head")[0].appendChild(script);
  })();
</script>
