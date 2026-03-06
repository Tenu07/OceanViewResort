package com.oceanview.model;

public class RoomType {
    private int typeId;
    private String typeName;
    private double baseRate;
    private String description;

    public RoomType() {}

    public RoomType(int typeId, String typeName, double baseRate, String description) {
        this.typeId = typeId;
        this.typeName = typeName;
        this.baseRate = baseRate;
        this.description = description;
    }

    // Getters and Setters
    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public double getBaseRate() {
        return baseRate;
    }

    public void setBaseRate(double baseRate) {
        this.baseRate = baseRate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return typeName + " - LKR " + String.format("%,.2f", baseRate);
    }
}