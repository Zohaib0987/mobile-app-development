# Create fonts directory if it doesn't exist
New-Item -ItemType Directory -Force -Path "../assets/fonts"

# Download Poppins font files
$fonts = @(
    "Regular",
    "Medium",
    "SemiBold",
    "Bold"
)

foreach ($weight in $fonts) {
    $url = "https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-$weight.ttf"
    $output = "../assets/fonts/Poppins-$weight.ttf"
    Invoke-WebRequest -Uri $url -OutFile $output
    Write-Host "Downloaded Poppins-$weight.ttf"
} 