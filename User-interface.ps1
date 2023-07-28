function MostraMenu {
    Clear-Host
    Write-Host "premi 1 per creare una nuova cartella"
    Write-Host "premi 2 per creare un nuovo file di testo"
    Write-Host "premi 3 per copiare una cartella"
    Write-Host "premi 4 per copiare un file"
    Write-Host "premi 5 per cancellare una cartella"
    Write-Host "premi 6 per cancellare un file"
    Write-Host "premi 7 per spostare una cartella"
    Write-Host "premi 8 per spostare un file"
    Write-Host "premi 9 per rinominare una cartella"
    Write-Host "premi 10 per rinominare un file"
    Write-Host "premi 11 per comprimere una cartella"
    Write-Host "premi 12 per estrarre una cartella"
    Write-Host "premi Q per uscire"
}
do {
    MostraMenu
    $scelta = Read-Host "fai una scelta: "
    switch ($scelta) {
        "1" {
            $parentPath = Read-Host "Inserisci il percorso della cartella padre: "
            $folderName = Read-Host "Inserisci il nome della nuova cartella: "
            CreateFolder -ParentFolderPath $parentPath -NewFolderName $folderName
        }
        "2" {
            $filePath = Read-Host "Inserisci il percorso dove creare il file: "
            $content = Read-Host "Inserisci il testo del file: "
            CreateTextFile -FilePath $filePath -Content $content
        }
        "3" {
            $sourcePath = Read-Host "Inserisci il percorso della cartella da copiare: "
            $destinationPath = Read-Host "Inserisci il percorso della cartella di destinazione: "
            CopyFolder -SourceFolderPath $sourcePath -DestinationFolderPath $destinationPath
        }
        "4" {
            $sourceFile = Read-Host "Inserisci il percorso del file da copiare: "
            $destinationFile = Read-Host "Inserisci il percorso del file di destinazione: "
            CopyFile -SourceFilePath $sourceFile -DestinationFilePath $destinationFile
        }
        "5" {
            $folderToDelete = Read-Host "Inserisci il percorso della cartella da cancellare: "
            DeleteFolder -FolderPath $folderToDelete
        }
        "6" {
            $fileToDelete = Read-Host "Inserisci il percorso del file da cancellare: "
            DeleteFile -FilePath $fileToDelete
        }
        "7" {
            $sourcePath = Read-Host "Inserisci il percorso della cartella da spostare: "
            $destinationParentPath = Read-Host "Inserisci il percorso della cartella padre di destinazione: "
            MoveFolder -SourceFolderPath $sourcePath -DestinationParentFolderPath $destinationParentPath
        }
        "8" {
            $sourceFile = Read-Host "Inserisci il percorso del file da spostare: "
            $destinationParentPath = Read-Host "Inserisci il percorso della cartella padre di destinazione: "
            MoveFile -SourceFilePath $sourceFile -DestinationParentFolderPath $destinationParentPath
        }
        "9" {
            $folderPath = Read-Host "Inserisci il percorso della cartella da rinominare: "
            $newName = Read-Host "Inserisci il nuovo nome della cartella: "
            RenameFolder -FolderPath $folderPath -NewName $newName
        }
        "10" {
            $filePath = Read-Host "Inserisci il percorso del file da rinominare: "
            $newName = Read-Host "Inserisci il nuovo nome del file: "
            RenameFile -FilePath $filePath -NewName $newName
        }
        "11" {
            $folderToCompress = Read-Host "Inserisci il percorso della cartella da comprimere: "
            CompressFolder -FolderPath $folderToCompress
        }
        "12" {
            $archivePath = Read-Host "Inserisci il percorso dell'archivio compresso: "
            $destinationPath = Read-Host "Inserisci il percorso di destinazione per l'estrazione: "
            ExtractFolder -ArchivePath $archivePath -DestinationPath $destinationPath
        }
    }
    Pause
} until ($scelta -eq 'q')


function CreateFolder {
    param (
        [string]$ParentFolderPath,
        [string]$NewFolderName
    )

    $NewFolderPath = Join-Path -Path $ParentFolderPath -ChildPath $NewFolderName

    if (-not (Test-Path $NewFolderPath -PathType Container)) {
        New-Item -Path $NewFolderPath -ItemType Directory | Out-Null
        Write-Host "Folder created: $NewFolderPath"
    }
    else {
        Write-Host "Folder already exists: $NewFolderPath"
    }
}

function CreateTextFile {
    param (
        [string]$FilePath,
        [string]$Content
    )

    if (-not (Test-Path $FilePath)) {
        $Content | Set-Content $FilePath
        Write-Host "Text file created: $FilePath"
    }
    else {
        Write-Host "File already exists: $FilePath"
    }
}

function CopyFolder {
    param (
        [string]$SourceFolderPath,
        [string]$DestinationFolderPath
    )

    if (Test-Path $SourceFolderPath -PathType Container) {
        Copy-Item $SourceFolderPath -Destination $DestinationFolderPath -Recurse
        Write-Host "Folder copied from $SourceFolderPath to $DestinationFolderPath"
    }
    else {
        Write-Host "Source folder does not exist: $SourceFolderPath"
    }
}

function CopyFile {
    param (
        [string]$SourceFilePath,
        [string]$DestinationFilePath
    )

    if (Test-Path $SourceFilePath -PathType Leaf) {
        Copy-Item $SourceFilePath -Destination $DestinationFilePath
        Write-Host "File copied from $SourceFilePath to $DestinationFilePath"
    }
    else {
        Write-Host "Source file does not exist: $SourceFilePath"
    }
}

function DeleteFolder {
    param (
        [string]$FolderPath
    )

    if (Test-Path $FolderPath -PathType Container) {
        Remove-Item $FolderPath -Recurse -Force
        Write-Host "Folder deleted: $FolderPath"
    }
    else {
        Write-Host "Folder not found: $FolderPath"
    }
}

function DeleteFile {
    param (
        [string]$FilePath
    )

    if (Test-Path $FilePath -PathType Leaf) {
        Remove-Item $FilePath -Force
        Write-Host "File deleted: $FilePath"
    }
    else {
        Write-Host "File not found: $FilePath"
    }
}

function MoveFolder {
    param (
        [string]$SourceFolderPath,
        [string]$DestinationParentFolderPath
    )

    if (Test-Path $SourceFolderPath -PathType Container) {
        $destinationPath = Join-Path -Path $DestinationParentFolderPath -ChildPath (Split-Path -Leaf $SourceFolderPath)
        Move-Item $SourceFolderPath -Destination $destinationPath
        Write-Host "Folder moved to: $destinationPath"
    }
    else {
        Write-Host "Source folder not found: $SourceFolderPath"
    }
}

function MoveFile {
    param (
        [string]$SourceFilePath,
        [string]$DestinationParentFolderPath
    )

    if (Test-Path $SourceFilePath -PathType Leaf) {
        $destinationPath = Join-Path -Path $DestinationParentFolderPath -ChildPath (Split-Path -Leaf $SourceFilePath)
        Move-Item $SourceFilePath -Destination $destinationPath
        Write-Host "File moved to: $destinationPath"
    }
    else {
        Write-Host "Source file not found: $SourceFilePath"
    }
}

function RenameFolder {
    param (
        [string]$FolderPath,
        [string]$NewName
    )

    if (Test-Path $FolderPath -PathType Container) {
        $newPath = Join-Path -Path (Split-Path -Parent $FolderPath) -ChildPath $NewName
        Rename-Item $FolderPath -NewName $NewName
        Write-Host "Folder renamed to: $newPath"
    }
    else {
        Write-Host "Folder not found: $FolderPath"
    }
}

function RenameFile {
    param (
        [string]$FilePath,
        [string]$NewName
    )

    if (Test-Path $FilePath -PathType Leaf) {
        $newPath = Join-Path -Path (Split-Path -Parent $FilePath) -ChildPath $NewName
        Rename-Item $FilePath -NewName $NewName
        Write-Host "File renamed to: $newPath"
    }
    else {
        Write-Host "File not found: $FilePath"
    }
}

function CompressFolder {
    param (
        [string]$FolderPath
    )

    if (Test-Path $FolderPath -PathType Container) {
        $archivePath = Join-Path -Path (Split-Path -Parent $FolderPath) -ChildPath "$([System.IO.Path]::GetFileNameWithoutExtension($FolderPath)).zip"
        Compress-Archive -Path $FolderPath -DestinationPath $archivePath
        Write-Host "Folder compressed to: $archivePath"
    }
    else {
        Write-Host "Folder not found: $FolderPath"
    }
}

function ExtractFolder {
    param (
        [string]$ArchivePath,
        [string]$DestinationPath
    )

    if (Test-Path $ArchivePath -PathType Leaf) {
        Expand-Archive -LiteralPath $ArchivePath -DestinationPath $DestinationPath
        Write-Host "Folder extracted to: $DestinationPath"
    }
    else {
        Write-Host "Archive not found: $ArchivePath"
    }
}


       
