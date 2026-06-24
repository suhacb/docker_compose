# Template for ENS3.Hosts.UI.
# Copy this file to:
#   ${SOURCE_DIR}/Hosts/UI/ENS3.Hosts.UI/Dockerfile
# and adjust the .csproj path if the project layout differs.
#
# Requires Telerik credentials at build time because ENS3.UI depends on
# Telerik.UI.for.Blazor. Pass them as build args (injected from CI secrets):
#   docker build --build-arg TELERIK_USERNAME=... --build-arg TELERIK_PASSWORD=...
# This is temporary — remove once issue #5 (Remove ENS3.UI) is merged.

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
ARG TELERIK_USERNAME
ARG TELERIK_PASSWORD
WORKDIR /src
COPY ["NuGet.config", "."]
RUN dotnet nuget add source https://nuget.telerik.com/v3/index.json \
    --name Telerik \
    --username "$TELERIK_USERNAME" \
    --password "$TELERIK_PASSWORD" \
    --store-password-in-clear-text
COPY ["Hosts/UI/ENS3.Hosts.UI/ENS3.Hosts.UI.csproj", "Hosts/UI/ENS3.Hosts.UI/"]
RUN dotnet restore "Hosts/UI/ENS3.Hosts.UI/ENS3.Hosts.UI.csproj"
COPY . .
WORKDIR "/src/Hosts/UI/ENS3.Hosts.UI"
RUN dotnet build "ENS3.Hosts.UI.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "ENS3.Hosts.UI.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ENS3.Hosts.UI.dll"]
