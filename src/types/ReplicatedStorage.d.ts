interface ReplicatedStorage extends Instance {
	TS: Folder & {
		wcs: Folder & {
            movesets: Folder;
            skills: Folder;
            statusEffects: Folder;
        },
        remotes: ModuleScript,
        utils: ModuleScript,
        vars: Folder & {
            folders: ModuleScript
        }
	};
}