import HealthSystem from "../frameworks/character/health";

export default new class Registry {
    private healthSystems: HealthSystem[] = [];

    getSystemForHumanoid(humanoid: Humanoid) {
        return this.healthSystems.find(system => system.humanoid === humanoid);
    }

    addHumanoid(humanoid: Humanoid) {
        const existingSystem = this.getSystemForHumanoid(humanoid);
        if (existingSystem) return existingSystem;

        const system = new HealthSystem(humanoid);
        system.addValidListener(() => {
            this.removeSystem(system);
        });
        this.healthSystems.push(system);
        return system;
    }

    removeHumanoid(humanoid: Humanoid) {
        const system = this.getSystemForHumanoid(humanoid);
        if (system) {
            this.removeSystem(system);
        }
    }

    private removeSystem(system: HealthSystem) {
        system.removeAllListeners();
        this.healthSystems = this.healthSystems.filter(existingSystem => existingSystem !== system);
    }
}
