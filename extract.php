<?php

  $fileID=$argv[1];
  $filename=$fileID . ".json";
  $string_array=trim(file_get_contents($filename));
  $json_array=substr($string_array, 11);
  $data_array=json_decode($json_array);
  $data_all=$data_array->{'job'}->{'spacers'};
  echo "score,sequence,n_offtargets" . "\n";
  for($i=0;$i<count($data_all);$i++) {
    echo $data_all[$i]->{'score'} . "," . $data_all[$i]->{'sequence'} . "," .  $data_all[$i]->{'n_offtargets'} . "\n";
  }
?>
