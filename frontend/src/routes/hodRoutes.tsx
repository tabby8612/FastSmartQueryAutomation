import { ProtectedRoute } from "@/components/protected-route";
import { Account } from "@/pages/Account";
import Dashboard from "@/pages/Dashboard";
import { HodIssues } from "@/pages/hod/HodIssues";
import { SearchPage } from "@/pages/Search";
import { Route } from "react-router-dom";

const PREFIX = "/hod";

export default [
  <Route
    path={`${PREFIX}/dashboard`}
    element={
      <ProtectedRoute allowedRoles={["hod"]}>
        <Dashboard />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/escalated-issues`}
    element={
      <ProtectedRoute allowedRoles={["hod"]}>
        <HodIssues />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/account`}
    element={
      <ProtectedRoute allowedRoles={["hod"]}>
        <Account />
      </ProtectedRoute>
    }
  />,

  <Route
    path={`${PREFIX}/search`}
    element={
      <ProtectedRoute allowedRoles={["hod"]}>
        <SearchPage />
      </ProtectedRoute>
    }
  />,
];
