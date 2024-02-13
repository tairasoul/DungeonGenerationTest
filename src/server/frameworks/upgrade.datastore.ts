import quicksave from "@rbxts/quicksave";
import { t } from "@rbxts/t";
import { QuicksaveDocument } from "@rbxts/quicksave/src/Quicksave/Document";

const UpgradeSchema = quicksave.createCollection("UpgradeData", {
    schema: {
        upgrades: t.array(t.string),
    },
    defaultData: {
        upgrades: []
    }
})

export default class UpgradeDatastore {
    private document: QuicksaveDocument<{upgrades: t.check<string[]>}>;
    static async init(name: string) {
        const document = await UpgradeSchema.getDocument(name);
        return new this(document);
    }
    private constructor(document: QuicksaveDocument<{upgrades: t.check<string[]>}>) {
        this.document = document;
    }

    getUpgrades() {
        return this.document.get("upgrades");
    }

    addUpgrades(...upg: string[]) {
        const upgrades = this.getUpgrades();
        this.document.set("upgrades", [...upgrades, ...upg]);
    }

    removeUpgrades(...upg: string[]) {
        const upgrades = this.getUpgrades();
        this.document.set("upgrades", upgrades.filter((v) => !upg.includes(v)));
    }

    async save() {
        this.document.save();
    }
}