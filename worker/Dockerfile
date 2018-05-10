#FROM microsoft/dotnet:2.0.0-sdk
FROM registry.access.redhat.com/dotnet/dotnet-20-runtime-rhel7

WORKDIR /code

ADD src/Worker /code/src/Worker

RUN dotnet restore -v minimal src/Worker \
    && dotnet publish -c Release -o "./" "src/Worker/" 

CMD dotnet src/Worker/Worker.dll
