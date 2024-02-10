import { Value, Observer } from "@rbxts/fusion";

export default class HealthSystem {
    maxHealth = Value(6);
    health = Value(this.maxHealth.get());
    maxShield = Value(3);
    shield = Value(this.maxShield.get());
    humanoid: Humanoid;
    observers = {
        health: Observer(this.health),
        shield: Observer(this.shield)
    }

    constructor(humanoid: Humanoid) {
        this.humanoid = humanoid;
    }

    takeDamage(damage: number) {
        if (this.shield.get() > 0)
            this.shield.set(this.shield.get() - damage);
        else
            this.health.set(this.health.get() - damage);
        if (this.health.get() === 0) {
            this.humanoid.Health = 0;
        }
    }
}