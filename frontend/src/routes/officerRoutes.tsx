import { ProtectedRoute } from "@/components/protected-route";
import { Route } from "react-router-dom";
import Dashboard from "../pages/Dashboard";
import { OfficerIssues } from "@/pages/officer/OfficerIssues";
import LeaveAutoReply from "@/pages/officer/LeaveAutoReply";
import { Account } from "@/pages/Account";
import { SearchPage } from "@/pages/Search";

const PREFIX = "/officer";

export default [
  <Route
    path={`${PREFIX}/dashboard`}
    element={
      <ProtectedRoute allowedRoles={["officer"]}>
        <Dashboard />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/issues`}
    element={
      <ProtectedRoute allowedRoles={["officer"]}>
        <OfficerIssues />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/leave`}
    element={
      <ProtectedRoute allowedRoles={["officer"]}>
        <LeaveAutoReply />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/account`}
    element={
      <ProtectedRoute allowedRoles={["officer"]}>
        <Account />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/search`}
    element={
      <ProtectedRoute allowedRoles={["officer"]}>
        <SearchPage />
      </ProtectedRoute>
    }
  />,
];
