import argparse
import os
import docker
from datetime import datetime
import json

with open('Preloaded.json',) as preloaded:
    Current_SupportedOrganisms = json.loads(preloaded.read())

def calldocker(reference,mutation,output,fast5=None,fastq=None):
    if fastq:
        fastq = constructPath(fastq)
        command = '--out {2} --ont-fastq {3} --threads 20 --overwrite --contamination --reference-genome={0} --mutation-regions={1} --genome-size 5.4m --verb 3'.format(
            reference,mutation,output,fastq)
    if fast5:
        fast5 = constructPath(fast5)
        command = '--out {2} --ont-fast5 {3} --threads 20 --overwrite --contamination --reference-genome={0} --mutation-regions={1} --genome-size 5.4m --verb 3'.format(
            reference, mutation, output, fast5)
    client = docker.from_env()
    try:
        runtime = client.containers.run(
            command=command,
            image='appliedbioinformaticslab/pima-docker:kraken',
            volumes={os.getcwd(): {'bind': '/home/DockerDir/mountpoint/', 'mode': 'rw'}},
            runtime="nvidia",
            detach=True,
        )
        print('logging:{0}'.format(datetime.now()))
        for line in runtime.logs(stream=True):
            print(line.strip())
        print('Finished:{0}'.format(datetime.now()))
    except KeyboardInterrupt: #Kill detached container too
        runtime.kill()
        raise

def constructPathO(Organism):
    reference = '/home/DockerDir/References/{0}/{0}.fasta'.format(Organism)
    mutation = '/home/DockerDir/References/{0}/{0}_r.bed'.format(Organism)
    return(reference,mutation)

def constructPath(name):
    return('/home/DockerDir/mountpoint/'+name)

# Setup Parser
parser = argparse.ArgumentParser(description='Pima docker python interface')

# Add mutually exclusive Fasta Group
fastgroup = parser.add_mutually_exclusive_group(required=True)
fastgroup.add_argument("-f","--Fast5",type=str,action="store",
                    help="Path to the Directory Containing Fast5 Files")
fastgroup.add_argument("-q","--Fastq",type=str,action="store",
                    help="Path to the Directory Containing Fastq Files")

# Add mutation and reference parser
parser.add_argument("-r","--reference_genome",type=str,action="store",
                    help="Path to the Reference Genome")
parser.add_argument("-m","--mutation",type=str,action="store",
                    help="Path to AMR mutation file")

# Add Preloaded Options
parser.add_argument("-R","--Preloded_Reference",type=str,action="store",choices=Current_SupportedOrganisms,
                    help="Select one of the preloaded Reference and Mutation Options")
# Add output file
parser.add_argument("-o","--output",type=str,action="store",required=True,
                    help="Path to output file")

# Handle Arguments
opts, _ = parser.parse_known_args()
opts = vars(opts)

# Control Logic
if not opts['Preloded_Reference'] and not opts['mutation']:
    raise ValueError('Mutations file not defined, nor preloaded organism given')

if not opts['Preloded_Reference'] and not opts['reference_genome']:
    raise ValueError('Reference file not defined, nor preloaded orgranism given')

# Define Reference and mutation paths

if opts['Preloded_Reference']:
    reference,mutation = constructPathO(opts['Preloded_Reference'])
else:
    reference = constructPath(opts['reference_genome'])
    mutation = constructPath(opts['mutation'])

if not os.path.exists(opts['output']):
    os.makedirs(opts['output'])

output = constructPath(opts['output'])

# Execute Docker
print('Executing:{0}'.format(datetime.now()))
calldocker(reference,mutation,output,opts['Fast5'],opts['Fastq'])

#bash -m samples_dod/reference/Ames/mutation_regions.bed -q samples_dod/combined.fastq -r samples_dod/reference/ref_genome.fasta -o test
#bash pima.sh -m samples_dod/reference/Ames/mutation_regions.bed -q samples_dod/combined.fastq -R klebsiella_pneumoniae -o test