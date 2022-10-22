# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY blazorapp/Client/*.csproj ./blazorapp/Client/
COPY blazorapp/Server/*.csproj ./blazorapp/Server/
COPY blazorapp/Shared/*.csproj ./blazorapp/Shared/
RUN dotnet restore

# copy everything else and build app
COPY blazorapp/Client/. ./blazorapp/Client/
COPY blazorapp/Server/. ./blazorapp/Server/
COPY blazorapp/Shared/. ./blazorapp/Shared/
WORKDIR /source/blazorapp
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "blazorapp.Server.dll"]