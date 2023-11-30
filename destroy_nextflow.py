"""
Destroy previous nextflow run
"""

import shutil
import os
shutil.rmtree('.nextflow')
shutil.rmtree('work')
os.remove('.nextflow.log')
