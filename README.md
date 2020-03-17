### NAME
tfnohup2dat - extract data from the tensorflow nohup log

### USAGE
    nohup python tf-script.py &
    tfnohup2dat [OPTIONS] nohup.out > loss.dat
    tfnohup2dat [OPTIONS] -a nohup.out
    tf-script.py | tfnohup2dat

### DESCRIPTION
It extracts the sample number, loss, accuracy, etc. from the TensorFlow
standard progress report, as stored by nohup.

Compressed input files file.gz, file.lz, or .zst are also accepted.

### OPTIONS
     -h  This help.
     -v  Verbose messaging.
     -a  Automatic output file(s) file.dat (file-N.dat).  Multiple-files
         output for the multi-run nohup.out is possible in this mode.
     -r  Print raw input with non-ASCII characters removed.

### VERSION
tfnohup2dat-0.2 (c) R.Jaksa 2019,2020 GPLv3

