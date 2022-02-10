import os
import shutil
import pandas as pd
import json

# This is a utility set up function that converts a folder of fasta files into a folder of Ames files
# Gene Symbol <- Name
# Class <- type
# Subclass <- drug
# Sequence name <- note

path = 'References'

#contig	start	stop	name	type	drug	note

Columns = ['Contig id','Start','Stop','Gene symbol','Class','Subclass','Sequence name']

# FIRST COLUMN is just chromosome

def reducefile(i):
    File = pd.read_csv(i,delimiter='\t')
    output = File[Columns]
    output.set_axis(['contig','start','stop','name','type','drug','note'],axis=1,inplace=True)
    output['contig'] = 'chromosome'
    output.to_csv(i.split('.')[0]+'_r.bed',sep='\t',index=False)

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
    return(Name)

Names = []

for i in os.listdir(path):
    if '.fasta' in i:
        Names.append(createmutdir(i))

with open("Preloaded.json","w") as outfile:
    json.dump(Names,outfile)
