import os
import shutil
import pandas as pd

# This is a utility set up function that converts a folder of fasta files into a folder of Ames files

path = 'Internal/References'

#contig	start	stop	name	type	drug	note

Columns = ['Contig id','Start','Stop','Sequence name','Element type','Class','HMM description']

def reducefile(i):
    File = pd.read_csv(i,delimiter='\t')
    output = File[Columns]
    output.to_csv(i.split('.')[0]+'_r.bed',sep='\t')

def createmutdir(i):
    Name = i.split('.')[0]
    Newdir = path+'/'+Name
    Oldpath = path+'/'+i
    Newpath = Newdir+'/'+Name+'.fasta'
    Mutpath = Newdir+'/'+Name+'.bed'
    os.mkdir(Newdir)
    shutil.copy(Oldpath,Newpath)
    os.system('amrfinder -n {0} --threads 8 -o {1}'.format(Newpath,Mutpath))
    reducefile(Mutpath)

for i in os.listdir(path):
    if '.fasta' in i:
        createmutdir(i)
