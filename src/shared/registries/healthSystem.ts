import HealthSystem from "../frameworks/character/health";

export default new class Registry {
    private HealthSystems: HealthSystem[] = [];

    getSystemForHumanoid(humanoid: Humanoid) {
        for (const system of this.HealthSystems) {
            if (system.humanoid === humanoid) {
                return system;
            }
        }
        return undefined;
    }

    addHumanoid(humanoid: Humanoid) {
        if (this.getSystemForHumanoid(humanoid)) return this.getSystemForHumanoid(humanoid) as HealthSystem;
        const system = new HealthSystem(humanoid)
        const callback = () => {
            this.HealthSystems = this.HealthSystems.filter((v) => v !== system);
            system.removeValidListener(callback);
            system.removeAllListeners();
        }
        system.addValidListener(callback)
        this.HealthSystems.push(system);
        return system;
    }

    removeHumanoid(humanoid: Humanoid) {
        if (this.HealthSystems.some((v) => v.humanoid === humanoid)) {
            const system = this.HealthSystems.find((v) => v.humanoid === humanoid) as HealthSystem;
            system.removeAllListeners();
            this.HealthSystems = this.HealthSystems.filter((v) => v !== system);
        }
    }
}