export default class FolderMerger {
    private _folder: Folder;
    constructor(folder: Folder) {
        this._folder = folder;
    }

    merge(folders: Folder[]) {
        for (const folder of folders) {
            for (const child of folder.GetChildren()) {
                child.Parent = this._folder;
            }
            folder.Destroy();
        }
    } 
}