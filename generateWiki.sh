#!/bin/bash
echo "Welcome to the WikiGenerator, what would you like to publish today?"
echo "1. Course main page"
echo "2. Course page for a specific week"
read buildTarget

generateMainPage () {
  echo "Not yet implemented"
}

generateWeeklyCoursePage () {
  echo "What's the course's name?"
  read courseName
  
  echo "How much weeks does this course take?"
  read numberOfWeeks
  
  echo "What's the current week?"
  read weekNumber
  
  echo "How many assignments for this week?"
  read numberOfAssignments
  
  
  assignmentTemplate="
=== Assignment %assignmentNumber% ===

\\\\
\\\\
[[ #$courseName - Week $weekNumber | Back to top ]]

"
  
  sideboxTemplate="
<sidebox title='Courses & Assignments'>
  + [[ ../ | Jeroen Schutrup ]]
  +> $courseName
    + [[ :latest | Homepage ]]
%weekEntries%
</sidebox>
"
  generatedSidebox=""
  generatedAssignments=""
  for i in `seq 1 $numberOfWeeks`; do
    if [ $i -eq $weekNumber ] ; then
      generatedSidebox+="    +> Week $i\n"
      for j in `seq 1 $numberOfAssignments`; do
        generatedSidebox+="      + [[ ::week$i#Assignment $j | Assignment $j ]]\n"
      done
    fi
    generatedSidebox+="    + [[ ::week$i | Week $i ]]\n"
  done
  
  generatedSidebox=$(echo "$sideboxTemplate" | sed -b -r "s/%weekEntries%/$generatedSidebox/g")
  
  for i in `seq 1 $numberOfAssignments`; do
    generatedAssignments+=$(echo "$assignmentTemplate" | sed -r 's/%assignmentNumber%/'$i'/g')
  done
  
  output="
==== $courseName - Week $weekNumber ====

----

$generatedAssignments

$generatedSidebox
"
  if [[ $(dpkg -s xclip) ]]; then
    echo "$output" | xclip -selection clipboard
    echo "The wiki page has been successfully generated, and it's copied to your clipboard. Use ^v to paste it."
  else
    echo "


    =================================================================================
$output
    =================================================================================

The wiki page has successfully been generated. BTW: consider installing xclip. If installed, the generated wiki will automatically be copied to your clipboard!

"
  fi
}

case $buildTarget in
  1)
    generateMainPage 
    ;;
  2)
    generateWeeklyCoursePage
    ;;
  *)
    echo "Exiting..."
esac
