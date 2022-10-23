# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source/BlazorApp

# copy everything
COPY . ./
# restore as distinct layers
RUN dotnet restore
# build and publish a release
RUN dotnet publish -c release -o out --no-restore

# build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /BlazorApp
COPY --from=build /source/BlazorApp/out ./
ENTRYPOINT ["dotnet", "blazorapp.Server.dll"]