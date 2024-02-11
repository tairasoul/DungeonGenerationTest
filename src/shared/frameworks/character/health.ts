import { Value, Observer } from "@rbxts/fusion";
import make from "@rbxts/make";

type listeners = {
    health: {callback: () => void, destroy: () => void}[];
    shield: {callback: () => void, destroy: () => void}[];
    valid: {callback: () => void, destroy: () => void}[];
}

export default class HealthSystem {
    maxHealth = Value(6);
    health = Value(this.maxHealth.get());
    maxShield = Value(3);
    shield = Value(this.maxShield.get());
    humanoid: Humanoid;
    canTakeDamage = false;
    private valid = Value(true);
    private observers = {
        health: Observer(this.health),
        shield: Observer(this.shield),
        valid: Observer(this.valid)
    }
    private listeners: listeners = {
        health: [],
        shield: [],
        valid: []
    }

    constructor(humanoid: Humanoid) {
        this.humanoid = humanoid;
        this.humanoid.Died.Once(() => {
            this.valid.set(false);
        })
    }

    addHealthListener(callback: () => void) {
        this.listeners.health.push({callback, destroy: this.observers.health.onChange(callback)});
    }

    addShieldListener(callback: () => void) {
        this.listeners.shield.push({callback, destroy: this.observers.shield.onChange(callback)});
    }

    addValidListener(callback: () => void) {
        this.listeners.valid.push({callback, destroy: this.observers.valid.onChange(callback)});
    }

    removeHealthListener(callback: () => void) {
        const listener = this.listeners.health.find((v) => v.callback === callback);
        if (listener !== undefined) {
            listener.destroy();
            this.listeners.health = this.listeners.health.filter((v) => v !== listener);
        }
    }

    removeShieldListener(callback: () => void) {
        const listener = this.listeners.shield.find((v) => v.callback === callback);
        if (listener !== undefined) {
            listener.destroy();
            this.listeners.shield = this.listeners.shield.filter((v) => v !== listener);
        }
    }

    removeValidListener(callback: () => void) {
        const listener = this.listeners.shield.find((v) => v.callback === callback);
        if (listener !== undefined) {
            listener.destroy();
            this.listeners.shield = this.listeners.shield.filter((v) => v !== listener);
        }
    }

    removeAllListeners() {
        this.listeners.shield.forEach((v) => v.destroy());
        this.listeners.health.forEach((v) => v.destroy());
        this.listeners.valid.forEach((v) => v.destroy());
        this.listeners.shield.clear();
        this.listeners.health.clear();
        this.listeners.valid.clear();
    }

    takeDamage(damage: number) {
        if (!this.canTakeDamage) return;
        if (this.shield.get() > 0)
            this.shield.set(this.shield.get() - damage);
        else
            this.health.set(this.health.get() - damage);
        if (this.health.get() === 0)
            this.humanoid.Health = 0;
    }

    healHealth(hp: number) {
        if (hp > this.maxHealth.get())
            hp = this.maxHealth.get();
        this.health.set(hp);
    }

    healShield(sp: number) {
        if (sp > this.maxShield.get())
            sp = this.maxShield.get();
        this.shield.set(sp);
    }
}