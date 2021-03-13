#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["helloWorld_webApp.csproj", "."]
RUN dotnet restore "./helloWorld_webApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "helloWorld_webApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "helloWorld_webApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "helloWorld_webApp.dll"]
CMD ["dotnet", "helloWorld_webApp.dll"]