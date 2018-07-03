FROM microsoft/dotnet:2.1-aspnetcore-runtime-nanoserver-1709 AS base
WORKDIR /app
EXPOSE 61922
EXPOSE 44339

FROM microsoft/dotnet:2.1-sdk-nanoserver-1709 AS build
WORKDIR /src
COPY CoreDockerWebTest/CoreDockerWebTest.csproj CoreDockerWebTest/
RUN dotnet restore CoreDockerWebTest/CoreDockerWebTest.csproj
COPY . .
WORKDIR /src/CoreDockerWebTest
RUN dotnet build CoreDockerWebTest.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish CoreDockerWebTest.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "CoreDockerWebTest.dll"]
