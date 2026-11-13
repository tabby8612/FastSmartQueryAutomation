import { ProtectedRoute } from "@/components/protected-route";
import { Account } from "@/pages/Account";
import { AdminDashboard } from "@/pages/admin/AdminDashboard";
import { AdminIssues } from "@/pages/admin/AdminIssues";
import { Announcement } from "@/pages/admin/Announcement";
import { AuditLogs } from "@/pages/admin/AuditLogs";
import { Categories } from "@/pages/admin/Categories";
import { CreateAdmin } from "@/pages/admin/CreateAdmin";
import CreateAnnouncement from "@/pages/admin/CreateAnnouncement";
import { CreateOfficer } from "@/pages/admin/CreateOfficer";
import { CreateStudent } from "@/pages/admin/CreateStudent";
import { Departments } from "@/pages/admin/Departments";
import { Users } from "@/pages/admin/Users";
import { SearchPage } from "@/pages/Search";
import { Route } from "react-router-dom";

const PREFIX = "/admin";

export default [
  <Route
    path={`${PREFIX}/dashboard`}
    element={
      <ProtectedRoute allowedRoles={["admin"]}>
        <AdminDashboard />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/issues`}
    element={
      <ProtectedRoute allowedRoles={["admin"]}>
        <AdminIssues />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/users`}
    element={
      <ProtectedRoute allowedRoles={["admin"]}>
        <Users />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/users/create-student`}
    element={
      <ProtectedRoute allowedRoles={["admin"]}>
        <CreateStudent />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/users/create-officer`}
    element={
      <ProtectedRoute allowedRoles={["admin"]}>
        <CreateOfficer />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/users/create-admin`}
    element={
      <ProtectedRoute allowedRoles={["admin"]}>
        <CreateAdmin />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/categories`}
    element={
      <ProtectedRoute allowedRoles={["admin"]}>
        <Categories />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/department`}
    element={
      <ProtectedRoute allowedRoles={["admin"]}>
        <Departments />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/announcements`}
    element={
      <ProtectedRoute allowedRoles={["admin"]}>
        <Announcement />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/announcements/create`}
    element={
      <ProtectedRoute allowedRoles={["admin"]}>
        <CreateAnnouncement />
      </ProtectedRoute>
    }
  />,
  <Route
    path={`${PREFIX}/audit-logs`}
    element={
      <ProtectedRoute allowedRoles={["admin"]}>
        <AuditLogs />
      </ProtectedRoute>
    }
  />,

  <Route
    path={`${PREFIX}/account`}
    element={
      <ProtectedRoute allowedRoles={["admin"]}>
        <Account />
      </ProtectedRoute>
    }
  />,

  <Route
    path={`${PREFIX}/search`}
    element={
      <ProtectedRoute allowedRoles={["admin"]}>
        <SearchPage />
      </ProtectedRoute>
    }
  />,
];
