import { useEffect, useState } from "react";
import api from "../components/api";

const SimulationCycle = () => {
  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await api.post("/simulationCycle");
      alert(JSON.stringify(response.data));
    } catch (err) {
      alert(err);
    }
  };

  return (
    <div>
      <fieldset>
        <form onSubmit={handleSubmit}>
          <button type="submit">Simulate Cycle</button>
        </form>
      </fieldset>
    </div>
  );
};

export default SimulationCycle;
