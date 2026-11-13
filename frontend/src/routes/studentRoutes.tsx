import { ProtectedRoute } from "@/components/protected-route";
import Dashboard from "../pages/Dashboard";
import { Route } from "react-router-dom";
import { StudentAnnouncements } from "@/pages/student/Announcements";
import { MyIssues } from "@/pages/student/MyIssues";
import SubmitIssue from "@/pages/student/SubmitIssue";
import { Account } from "@/pages/Account";
import { SearchPage } from "@/pages/Search";

const PREFIX = "/student";

export default [
  <Route
    path={`${PREFIX}/dashboard`}
    element={
      <ProtectedRoute allowedRoles={["student"]}>
        <Dashboard />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/announcements`}
    element={
      <ProtectedRoute allowedRoles={["student"]}>
        <StudentAnnouncements />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/my-issues`}
    element={
      <ProtectedRoute allowedRoles={["student"]}>
        <MyIssues />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/submit-issue`}
    element={
      <ProtectedRoute allowedRoles={["student"]}>
        <SubmitIssue />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/account`}
    element={
      <ProtectedRoute allowedRoles={["student"]}>
        <Account />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/search`}
    element={
      <ProtectedRoute allowedRoles={["student"]}>
        <SearchPage />
      </ProtectedRoute>
    }
  />,
];
