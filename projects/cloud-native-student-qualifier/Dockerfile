# Portfolio reconstruction of the CNA261 container workflow.
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .
RUN dotnet new console -n StudentQualificationApp -f net8.0 --force >/dev/null \
    && cp src/Program.cs StudentQualificationApp/Program.cs \
    && dotnet publish StudentQualificationApp/StudentQualificationApp.csproj -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/runtime:8.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "StudentQualificationApp.dll"]
