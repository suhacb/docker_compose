# Template for ENS3.Hosts.Workflow.
# Copy this file to:
#   ${SOURCE_DIR}/Hosts/Workflow/ENS3.Hosts.Workflow/Dockerfile
# and adjust the .csproj path if the project layout differs.

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["NuGet.config", "."]
COPY ["Hosts/Workflow/ENS3.Hosts.Workflow/ENS3.Hosts.Workflow.csproj", "Hosts/Workflow/ENS3.Hosts.Workflow/"]
RUN dotnet restore "Hosts/Workflow/ENS3.Hosts.Workflow/ENS3.Hosts.Workflow.csproj"
COPY . .
WORKDIR "/src/Hosts/Workflow/ENS3.Hosts.Workflow"
RUN dotnet build "ENS3.Hosts.Workflow.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "ENS3.Hosts.Workflow.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ENS3.Hosts.Workflow.dll"]
