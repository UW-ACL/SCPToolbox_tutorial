##################################
### Graphics helper functions ####
##################################

PyPlot.svg(true)
@pyimport matplotlib.animation as matplotlib_animation

function set_fonts()::Nothing
    # Set the figure fonts.
    fig_smaller_sz = 13
    fig_small_sz = 14
    fig_med_sz = 15
    fig_big_sz = 17
    plt.rc("text", usetex=true)
    plt.rc("font", size=fig_small_sz, family="serif")
    plt.rc("axes", titlesize=fig_small_sz)
    plt.rc("axes", labelsize=fig_small_sz)
    plt.rc("xtick", labelsize=fig_smaller_sz)
    plt.rc("ytick", labelsize=fig_smaller_sz)
    plt.rc("legend", fontsize=fig_smaller_sz)
    plt.rc("figure", titlesize=fig_big_sz)
    plt.rc("figure", dpi=150) 
    plt.rc("figure", figsize = [7, 5])
    plt.rc("axes", xmargin=0)
    plt.rc("animation", html="html5")
    return nothing
end
;

set_fonts()
set_fonts()

#######################
### Trajectory plot ###
#######################

function plot_trajectory() 

    fig = plt.figure(figsize=(9, 6))

    ctres, overlap = Nc, 3

    # speed
    vct = [norm(xc[3:4, i], 2) for i=1:size(xc[3:4, :])[2]]

    cmap = generate_colormap("viridis"; minval=minimum(vct), maxval=maximum(vct))

    ax = setup_axis!(111, xlabel="Downrange [m]", ylabel="Altitude [m]",
                     axis="equal", cbar=cmap, clabel="Speed [m/s]",
                     cbar_aspect=40)

    ax.grid(color="0.9")

    # Thrust vector profile (inertial frame)
    ux = []
    uy = []
    for i in 1:N
        append!(ux, -ud[1, i].*sin(xd[5, i] + ud[2, i]))
        append!(uy,  ud[1, i].*cos(xd[5, i] + ud[2, i]))
    end

    for i in 1:N
    #     ax.plot(xd[1, i], xd[2, i], linewidth=0, color="darkslategrey", marker=(4, 0, 45+rad2deg(xd[5, i])), ms=5, markerfacecolor="goldenrod", alpha=1, markeredgewidth=1, zorder=100)
        ax.quiver(xd[1, i], xd[2, i], sin(xd[5, i]), -cos(xd[5, i]), color="darkslategrey", pivot="middle", headaxislength=0, headlength=0, antialiased="True", width=0.015, scale=22.5, joinstyle="round", zorder=100)
        ax.quiver(xd[1, i], xd[2, i], -ux[i], -uy[i], color="tomato", pivot="tail", headaxislength=0, headlength=0, antialiased="True", width=0.0035, scale=11.5*T_max, zorder=20)
    end

    ax.plot(xd[1, :], xd[2, :], linewidth=0, color="k", marker="o", ms=5, markerfacecolor="goldenrod", alpha=1, markeredgewidth=0.625, zorder=100000, label="Guidance solution")
    # ax.plot(xc[1, :], xc[2, :], linewidth=1, color="mediumseagreen", label="Continuous-time dynamics", alpha=0.75, zorder=1000)

    span_gs = max(100, 2.25*abs(x_0[1]))
    x_cone = [-span_gs; 0; span_gs]
    ax.plot(x_cone, tan(γ_gs).*abs.(x_cone), linewidth=1.5, linestyle="dashed", color="slategrey", alpha=0.75, dash_capstyle="round", label="Glide-slope")

    line_segs = Vector{Matrix}(undef, 0)
    line_clrs = Vector{NTuple{4, Real}}(undef, 0)
    for k=1:ctres-overlap
        push!(line_segs, xc[1:2, k:k+overlap]')
        push!(line_clrs, cmap.to_rgba(vct[k]))
    end
    trajectory = PyPlot.matplotlib.collections.LineCollection(
        line_segs, zorder=1000, colors = line_clrs, linewidths=2,
        capstyle="round")
    ax.add_collection(trajectory)

    plt.title("\\textbf{Rocket-landing trajectory}", fontsize=13, pad=12.5)
    ax.legend(loc=2)

    # fig.savefig("traj.pdf", format="pdf", bbox_inches = "tight")
    ;
    
end

################################
### Trajectory visualization ###
################################

function visualize_trajectory()

    fig = plt.figure(figsize=(7, 5))

    ctres, overlap = Nc, 3

    # speed
    vct = [norm(xc[3:4, i], 2) for i=1:size(xc[3:4, :])[2]]

    cmap = generate_colormap("viridis"; minval=minimum(vct), maxval=maximum(vct))

    ax = setup_axis!(111, xlabel="Downrange [m]", ylabel="Altitude [m]",
                     axis="equal", cbar=cmap, clabel="Speed [m/s]",
                     cbar_aspect=40)

    ax.grid(color="0.9")

    # Thrust vector profile (inertial frame)
    ux = []
    uy = []
    for i in 1:N
        append!(ux, -ud[1, i].*sin(xd[5, i] + ud[2, i]))
        append!(uy,  ud[1, i].*cos(xd[5, i] + ud[2, i]))
    end

    # Thrust vector profile (inertial frame)
    uxc = []
    uyc = []
    for i in 1:Nc
        append!(uxc, -uc[1, i].*sin(xc[5, i] + uc[2, i]))
        append!(uyc,  uc[1, i].*cos(xc[5, i] + uc[2, i]))
    end

    # ax.plot(xd[1, :], xd[2, :], linewidth=0, color="k", marker="o", ms=3.5, markerfacecolor="goldenrod", alpha=1, markeredgewidth=0.5, zorder=100000, label="Guidance solution")

    span_gs = max(100, 2.25*abs(x_0[1]))
    x_cone = [-span_gs; 0; span_gs]
    ax.plot(x_cone, tan(γ_gs).*abs.(x_cone), linewidth=1.25, linestyle="dashed", color="slategrey", alpha=0.75, dash_capstyle="round", label="Glide-slope")

    line_segs = Vector{Matrix}(undef, 0)
    line_clrs = Vector{NTuple{4, Real}}(undef, 0)
    for k=1:ctres-overlap
        push!(line_segs, xc[1:2, k:k+overlap]')
        push!(line_clrs, cmap.to_rgba(vct[k]))
    end
    trajectory = PyPlot.matplotlib.collections.LineCollection(
        line_segs, zorder=1, colors = line_clrs, linewidths=1.25,
        capstyle="round")
    ax.add_collection(trajectory)

    global line1 = ax.quiver(1,1,1,1, alpha=0)
    global line2 = ax.quiver(1,1,1,1, alpha=0)

    function animate(i)
        global line1, line2
        if i == 0
            line = ax.plot(0, 0, linewidth=0)
        else
            line1.remove()
            line2.remove()
            # line0 = ax.plot(xc[1, i], xc[2, i], linewidth=0, color="k", marker="o", ms=3.5, markerfacecolor="goldenrod", alpha=1, markeredgewidth=0.5, zorder=100000)
            line1 = ax.quiver(xc[1, i], xc[2, i], sin(xc[5, i]), -cos(xc[5, i]), color="darkslategrey", pivot="middle", headaxislength=0, headlength=0, antialiased="True", width=0.015, scale=22.5, joinstyle="round", zorder=100)
            line2 = ax.quiver(xc[1, i], xc[2, i], -uxc[i], -uyc[i], color="tomato", pivot="tail", headaxislength=0, headlength=0, antialiased="True", width=0.0035, scale=11.5*T_max, zorder=20)
            return line1, line2
        end
    end

    plt.title("Rocket-landing trajectory", fontsize=13, pad=12.5)
    ax.legend(fontsize=12, loc=2)
    
    anim = matplotlib_animation.FuncAnimation(fig, animate, frames=Nc, interval=60)
    # plt.show()
    
    video = anim.to_html5_video()
    html = IJulia.HTML(video)
    IJulia.display(html)
    plt.close()
    
    ;

end

##############
### States ###
##############

function plot_states()
    
    fig, axs = plt.subplots(3, 2, sharex="col", figsize=(12, 8))

    line1 = axs[1, 1].plot(tc, xc[1, :], linewidth=1.5, color="darkslategrey", label="Propagated")
    line2 = axs[1, 1].plot(td, xd[1, :], linewidth=0, color="k", marker="o", ms=5, markerfacecolor="mediumspringgreen", alpha=0.75, label="Guidance", clip_on=false, zorder=1e8)
    axs[1, 1].set_ylabel("Downrange [m]", fontsize=12)
    axs[1, 1].tick_params(bottom=false)
    axs[1, 1].grid(color="0.9")
    # axs[1, 1].legend(fontsize=8)

    line1 = axs[2, 1].plot(tc, xc[2, :], linewidth=1.5, color="darkslategrey", label="Propagated")
    line2 = axs[2, 1].plot(td, xd[2, :], linewidth=0, color="k", marker="o", ms=5, markerfacecolor="orangered", alpha=0.75, label="Guidance", clip_on=false, zorder=1e8)
    axs[2, 1].set_ylabel("Altitude [m]", fontsize=12)
    axs[2, 1].tick_params(bottom=false)
    axs[2, 1].grid(color="0.9")
    # axs[2, 1].legend(fontsize=8)

    line1 = axs[3, 1].plot(tc, [rad2deg(xc[5, i]) for i in 1:Nc], linewidth=1.5, color="darkslategrey", label="Propagated")
    line2 = axs[3, 1].plot(td, [rad2deg(xd[5, i]) for i in 1:N], linewidth=0, color="k", marker="o", ms=5, markerfacecolor="dodgerblue", alpha=0.75, label="Guidance", clip_on=false, zorder=1e8)
    axs[3, 1].set_ylabel("Pitch [\$^\\circ\$]", fontsize=12)
    axs[3, 1].grid(color="0.9")
    # plt.legend(fontsize=8)

    line1 = axs[1, 2].plot(tc, xc[3, :], linewidth=1.5, color="darkslategrey", label="Propagated")
    line2 = axs[1, 2].plot(td, xd[3, :], linewidth=0, color="k", marker="o", ms=5, markerfacecolor="mediumspringgreen", alpha=0.75, label="Guidance", clip_on=false, zorder=1e8)
    axs[1, 2].set_ylabel("Longitudinal velocity [m/s]", fontsize=12)
    axs[1, 2].tick_params(bottom=false)
    axs[1, 2].grid(color="0.9")
    # axs[1, 2].legend(fontsize=8)

    line1 = axs[2, 2].plot(tc, xc[4, :], linewidth=1.5, color="darkslategrey", label="Propagated")
    line2 = axs[2, 2].plot(td, xd[4, :], linewidth=0, color="k", marker="o", ms=5, markerfacecolor="orangered", alpha=0.75, label="Guidance", clip_on=false, zorder=1e8)
    axs[2, 2].set_ylabel("Rate-of-descent [m/s]", fontsize=12)
    axs[2, 2].tick_params(bottom=false)
    axs[2, 2].grid(color="0.9")
    # axs[2, 2].legend(fontsize=8)

    line1 = axs[3, 2].plot(tc, [rad2deg(xc[6, i]) for i in 1:Nc], linewidth=1.5, color="darkslategrey", label="Propagated")
    line2 = axs[3, 2].plot(td, [rad2deg(xd[6, i]) for i in 1:N], linewidth=0, color="k", marker="o", ms=5, markerfacecolor="dodgerblue", alpha=0.75, label="Guidance", clip_on=false, zorder=1e8)
    axs[3, 2].set_ylabel("Pitch rate [\$^\\circ\$/s]", fontsize=12)
    axs[3, 2].grid(color="0.9")
    # plt.legend(fontsize=8)

    # handles, labels = axs[2, 1].get_legend_handles_labels()
    # fig.legend(handles, labels, loc="upper center")

    legend_elements = [PyPlot.matplotlib.lines.Line2D([0], [0], linewidth=0, color="k", marker="o", ms=5, markerfacecolor="white", alpha=0.75, label="Guidance", clip_on=false, zorder=1e8),
                       PyPlot.matplotlib.lines.Line2D([0], [0], color="darkslategrey", linewidth=1.5, label="Propagated"),]

    fig.legend(handles=legend_elements, ncol=2, loc="lower right", bbox_to_anchor=(0, 0.9075, 0.9075, 0), fontsize="12", mode="normal")

    # fig.legend(handles=legend_elements, loc="upper center")

    axs[3, 1].set_xlabel("Time [s]", fontsize=12)
    axs[3, 2].set_xlabel("Time [s]", fontsize=12)
    ;
    
end

####################
### Mass history ###
####################

function plot_mass()
    
    fig = plt.figure(figsize=(6, 3))
    ax = fig.add_subplot(111)

    ax.grid(color="0.9")

    ax.plot(td, xd[7, :], linewidth=1.5, color="darkslategrey", marker="o", ms=5, markeredgecolor="k", markerfacecolor="goldenrod", alpha=1, clip_on=false, zorder=1e8)

    ax.set_xlabel("Time [s]")
    ax.set_ylabel("Mass [kg]");
    ;
    
end

################
### Controls ###
################

function plot_controls()
    
    #########################
    ### Thrust magnitude ####
    #########################
    
    fig = plt.figure(figsize=(6, 3))
    ax = fig.add_subplot(111)

    ax.grid(color="0.9")

    ax.plot(td, ud[1, :]/1e3, linewidth=1.5, color="darkslategrey", marker="o", ms=5, markeredgecolor="k", markerfacecolor="goldenrod", alpha=1, clip_on=false, zorder=1e8)
    ax.axhline(y=T_min/1e3, color="steelblue", linewidth=1.5, linestyle="dashed", dash_capstyle="round", label="Throttle limits")
    ax.axhline(y=T_max/1e3, color="steelblue", linewidth=1.5, linestyle="dashed", dash_capstyle="round")

    ax.legend(loc="best", bbox_to_anchor=(0.5, 0.05, 0.5, 0.5))

    ax.set_xlabel("Time [s]")
    ax.set_ylabel("Thrust magnitude [kN]");
    
    #####################
    ### Gimbal angle ####
    #####################
    
    fig = plt.figure(figsize=(6, 3))
    ax = fig.add_subplot(111)

    ax.grid(color="0.9")

    ax.plot(td, [rad2deg(ud[2, i]) for i in 1:N], linewidth=1.5, color="darkslategrey", marker="o", ms=5, markeredgecolor="k", markerfacecolor="mediumspringgreen", alpha=1, clip_on=false, zorder=1e8)
    ax.axhline(y=rad2deg(δ_max), color="tomato", linewidth=1.5, linestyle="dashed", dash_capstyle="round", label="Gimbal limits")
    ax.axhline(y=-rad2deg(δ_max), color="tomato", linewidth=1.5, linestyle="dashed", dash_capstyle="round")

    ax.legend(loc="best", bbox_to_anchor=(0.5, 0.05, 0.5, 0.5))

    ax.set_xlabel("Time [s]")
    ax.set_ylabel("Gimbal angle [\$^\\circ\$]");
    
end

######################
### Time-of-flight ###
######################

function plot_ToF()
    
    fig = plt.figure(figsize=(6, 3))
    ax = fig.add_subplot(111)

    ax.grid(color="0.9")

    ax.plot(tf_values, linewidth=1.5, color="darkslategrey", marker="o", ms=5, markeredgecolor="k", markerfacecolor="coral", alpha=1, clip_on=false, zorder=1e8)

    ax.set_xlabel("SCP iteration")
    ax.set_ylabel("Time-of-flight [s]");
    
end