export default class FolderMerger {
    private targetFolder: Folder;

    constructor(folder: Folder) {
        this.targetFolder = folder;
    }

    public merge(...folders: (Folder | undefined)[]): void {
        for (const folder of folders) {
            if (folder) {
                this.moveChildren(folder);
                this.destroyFolder(folder);
            }
        }
    }

    private moveChildren(folder: Folder): void {
        const children = folder.GetChildren();
        for (const child of children) {
            child.Parent = this.targetFolder;
        }
    }

    private destroyFolder(folder: Folder): void {
        folder.Destroy();
    }
}
