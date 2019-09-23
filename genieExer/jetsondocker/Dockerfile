FROM balenalib/jetson-nano

# install basic apt packages
RUN apt-get update && apt-get install build-essential libatomic1 python gfortran perl wget m4 cmake pkg-config

RUN wget https://julialang-s3.julialang.org/bin/linux/aarch64/1.2/julia-1.2.0-linux-aarch64.tar.gz && tar xfvz julia-1.2.0-linux-aarch64.tar.gz

ENV PATH=/julia-1.2.0/bin:$PATH

RUN julia -e 'using Pkg; Pkg.add("Genie"); using Genie'

# clean up
RUN apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN julia -e 'using Genie; Genie.newapp("GOMAchan")'
