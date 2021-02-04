# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
ARG BUILD_CONFIGURATION=Debug
ENV ASPNETCORE_ENVIRONMENT=Development
ENV DOTNET_USE_POLLING_FILE_WATCHER=true  
ENV ASPNETCORE_URLS=http://+:80  
WORKDIR /source
EXPOSE 80
EXPOSE 5000
# copy csproj and restore as distinct layers
COPY *.csproj .
RUN dotnet restore

# copy and publish app and libraries
COPY . .
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "bla.dll", "--urls", "http://0.0.0.0:5000"]

# docker run -it --rm -p 5000:80 --name aspnetcore_sample aspnetapp
